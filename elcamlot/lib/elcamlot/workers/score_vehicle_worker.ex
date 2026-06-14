defmodule Elcamlot.Workers.ScoreVehicleWorker do
  @moduledoc """
  Oban worker that computes and records the deal score for a single vehicle.
  """
  use Oban.Worker, queue: :default, max_attempts: 3

  alias Elcamlot.{Repo, Vehicles, Analytics}
  alias Elcamlot.Vehicles.PriceSnapshot
  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"vehicle_id" => vehicle_id}}) do
    vehicle = Vehicles.get_vehicle!(vehicle_id)

    market_prices = Vehicles.get_market_prices(vehicle.id)

    if length(market_prices) < 3 do
      {:cancel, :insufficient_data}
    else
      # Use the most recent snapshot price (first in desc order)
      latest_snapshot =
        from(p in PriceSnapshot,
          where: p.vehicle_id == ^vehicle.id,
          order_by: [desc: p.time],
          limit: 1
        )
        |> Repo.one()

      if is_nil(latest_snapshot) do
        {:cancel, :no_snapshots}
      else
        vehicle_price = latest_snapshot.price_cents
        market_avg = div(Enum.sum(market_prices), length(market_prices))

        case Analytics.deal_score(vehicle_price, market_prices) do
          {:ok, result} ->
            Vehicles.record_deal_score(vehicle, %{
              score: result["score"] || 0.0,
              percentile_rank: result["percentile_rank"],
              market_avg_cents: market_avg,
              vehicle_price_cents: vehicle_price
            })
            :ok

          {:error, reason} ->
            {:error, reason}
        end
      end
    end
  end
end
