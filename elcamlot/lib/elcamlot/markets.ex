defmodule Elcamlot.Markets do
  @moduledoc """
  Context for financial market data — instruments and price bars.
  """
  import Ecto.Query
  alias Elcamlot.Repo
  alias Elcamlot.Markets.{Instrument, PriceBar}

  # --- Instruments ---

  def list_instruments do
    from(i in Instrument, order_by: [asc: i.symbol])
    |> Repo.all()
  end

  def get_instrument!(id), do: Repo.get!(Instrument, id)

  def get_instrument_by_symbol(symbol) do
    Repo.get_by(Instrument, symbol: String.upcase(symbol))
  end

  def create_instrument(attrs) do
    %Instrument{}
    |> Instrument.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_instrument(attrs) do
    %Instrument{}
    |> Instrument.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:name, :exchange, :status]},
      conflict_target: :symbol
    )
  end

  # --- Price Bars ---

  def insert_bars(bars) when is_list(bars) do
    Repo.insert_all(PriceBar, bars)
  end

  @doc "Insert bars with ON CONFLICT DO NOTHING (safe for repeated polling)."
  def upsert_bars(bars) when is_list(bars) do
    Repo.insert_all(PriceBar, bars, on_conflict: :nothing)
  end

  def list_bars(instrument_id, opts \\ []) do
    timeframe = Keyword.get(opts, :timeframe, "1D")
    limit = Keyword.get(opts, :limit, 365)

    from(b in PriceBar,
      where: b.instrument_id == ^instrument_id and b.timeframe == ^timeframe,
      order_by: [desc: b.time],
      limit: ^limit
    )
    |> Repo.all()
  end

  def latest_bar(instrument_id, timeframe \\ "1D") do
    from(b in PriceBar,
      where: b.instrument_id == ^instrument_id and b.timeframe == ^timeframe,
      order_by: [desc: b.time],
      limit: 1
    )
    |> Repo.one()
  end

  def price_stats(instrument_id, timeframe \\ "1D") do
    query = """
    SELECT
      COUNT(*) as count,
      ROUND(AVG(close_cents))::bigint as avg_price,
      MIN(close_cents) as min_price,
      MAX(close_cents) as max_price,
      ROUND(STDDEV(close_cents))::bigint as std_dev,
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY close_cents)::bigint as median,
      MIN(time) as first_bar,
      MAX(time) as last_bar
    FROM price_bars
    WHERE instrument_id = $1 AND timeframe = $2
    """

    case Repo.query(query, [instrument_id, timeframe]) do
      {:ok, %{rows: [row], columns: cols}} ->
        Enum.zip(cols, row)
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
        |> Map.new()

      _ ->
        %{}
    end
  end
end
