defmodule Elcamlot.Vehicles do
  @moduledoc """
  Context for vehicle data and price tracking.
  """
  import Ecto.Query
  alias Elcamlot.Repo
  alias Elcamlot.Vehicles.{Vehicle, PriceSnapshot, DealScore, SearchQuery}

  # --- Vehicles ---

  def list_vehicles do
    from(v in Vehicle,
      left_join: p in PriceSnapshot, on: p.vehicle_id == v.id,
      group_by: v.id,
      order_by: [asc: v.make, asc: v.model, desc: v.year],
      select: %{v | trim: v.trim},
      select_merge: %{
        avg_price: type(fragment("ROUND(AVG(?))::bigint", p.price_cents), :integer),
        snapshot_count: count(p.vehicle_id),
        latest_snapshot_at: max(p.time)
      }
    )
    |> Repo.all()
  end

  def list_makes do
    from(v in Vehicle, select: v.make, distinct: true, order_by: v.make)
    |> Repo.all()
  end

  def list_vehicles_by_make(make) do
    from(v in Vehicle,
      left_join: p in PriceSnapshot, on: p.vehicle_id == v.id,
      where: v.make == ^make,
      group_by: v.id,
      order_by: [asc: v.model, desc: v.year],
      select: %{v | trim: v.trim},
      select_merge: %{
        avg_price: type(fragment("ROUND(AVG(?))::bigint", p.price_cents), :integer),
        snapshot_count: count(p.vehicle_id),
        latest_snapshot_at: max(p.time)
      }
    )
    |> Repo.all()
  end

  def get_vehicle!(id), do: Repo.get!(Vehicle, id)

  def find_or_create_vehicle(attrs) do
    query =
      from v in Vehicle,
        where: v.make == ^attrs.make and v.model == ^attrs.model and v.year == ^attrs.year

    query =
      if attrs[:trim],
        do: from(v in query, where: v.trim == ^attrs.trim),
        else: query

    case Repo.one(query) do
      nil -> create_vehicle(attrs)
      vehicle -> {:ok, vehicle}
    end
  end

  def create_vehicle(attrs) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
  end

  def search_vehicles(term) do
    like = "%#{term}%"

    from(v in Vehicle,
      left_join: p in PriceSnapshot, on: p.vehicle_id == v.id,
      where: ilike(v.make, ^like) or ilike(v.model, ^like),
      group_by: v.id,
      order_by: [desc: v.year],
      limit: 50,
      select: %{v | trim: v.trim},
      select_merge: %{
        avg_price: type(fragment("ROUND(AVG(?))::bigint", p.price_cents), :integer),
        snapshot_count: count(p.vehicle_id),
        latest_snapshot_at: max(p.time)
      }
    )
    |> Repo.all()
  end

  # --- Price Snapshots ---

  def list_price_snapshots(vehicle_id) do
    from(p in PriceSnapshot,
      where: p.vehicle_id == ^vehicle_id,
      order_by: [desc: p.time]
    )
    |> Repo.all()
  end

  def create_price_snapshot(attrs) do
    %PriceSnapshot{}
    |> PriceSnapshot.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  def get_market_prices(vehicle_id) do
    from(p in PriceSnapshot,
      where: p.vehicle_id == ^vehicle_id,
      select: p.price_cents
    )
    |> Repo.all()
  end

  def price_stats(vehicle_id) do
    query = """
    SELECT
      COUNT(price_cents) AS count,
      ROUND(AVG(price_cents))::bigint AS avg_price,
      MIN(price_cents) AS min_price,
      MAX(price_cents) AS max_price,
      MAX(time) AS latest,
      ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price_cents))::bigint AS median,
      ROUND(STDDEV(price_cents))::bigint AS std_dev,
      ROUND(PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY price_cents))::bigint AS p10,
      ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price_cents))::bigint AS p25,
      ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price_cents))::bigint AS p75,
      ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY price_cents))::bigint AS p90,
      ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price_cents)
        - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price_cents))::bigint AS iqr
    FROM price_snapshots
    WHERE vehicle_id = $1
    """

    case Ecto.Adapters.SQL.query(Repo, query, [vehicle_id]) do
      {:ok, %{columns: columns, rows: [row]}} ->
        Enum.zip(columns, row)
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
        |> Map.new()

      _ ->
        %{count: 0, avg_price: nil, min_price: nil, max_price: nil}
    end
  end

  def price_trends(vehicle_id, time_bucket \\ "1 day") do
    query = """
    SELECT
      time_bucket($1::interval, time) AS bucket,
      AVG(price_cents) AS avg_price,
      MIN(price_cents) AS min_price,
      MAX(price_cents) AS max_price,
      COUNT(*) AS count
    FROM price_snapshots
    WHERE vehicle_id = $2
    GROUP BY bucket
    ORDER BY bucket DESC
    """

    Ecto.Adapters.SQL.query!(Repo, query, [time_bucket, vehicle_id])
  end

  @doc "Get days-on-market distribution for a vehicle's listings."
  def days_on_market_stats(vehicle_id) do
    query = """
    SELECT
      EXTRACT(DAY FROM (NOW() - MIN(time)))::integer AS days_on_market,
      url,
      MIN(price_cents) AS min_price,
      MAX(price_cents) AS max_price,
      COUNT(*) AS times_seen
    FROM price_snapshots
    WHERE vehicle_id = $1 AND url IS NOT NULL
    GROUP BY url
    ORDER BY days_on_market DESC
    """

    case Ecto.Adapters.SQL.query(Repo, query, [vehicle_id]) do
      {:ok, %{rows: rows, columns: columns}} ->
        Enum.map(rows, fn row -> Enum.zip(columns, row) |> Map.new() end)

      {:error, _} ->
        []
    end
  end

  # --- Deal Scores ---

  @doc "Record a deal score for a vehicle."
  def record_deal_score(vehicle, score_data) do
    %DealScore{}
    |> DealScore.changeset(
      Map.merge(score_data, %{
        vehicle_id: vehicle.id,
        computed_at: DateTime.utc_now()
      })
    )
    |> Repo.insert()
  end

  @doc "Get deal score history for a vehicle, ordered by computed_at ascending."
  def deal_score_history(vehicle_id, opts \\ []) do
    limit = Keyword.get(opts, :limit, 90)

    from(ds in DealScore,
      where: ds.vehicle_id == ^vehicle_id,
      order_by: [asc: ds.computed_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc "Get the most recent deal score for a vehicle."
  def latest_deal_score(vehicle_id) do
    from(ds in DealScore,
      where: ds.vehicle_id == ^vehicle_id,
      order_by: [desc: ds.computed_at],
      limit: 1
    )
    |> Repo.one()
  end

  # --- Search Queries ---

  def log_search(query, result_count) do
    %SearchQuery{}
    |> SearchQuery.changeset(%{
      query: query,
      result_count: result_count,
      searched_at: DateTime.utc_now()
    })
    |> Repo.insert()
  end
end
