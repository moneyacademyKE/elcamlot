defmodule Elcamlot.Workers.DealScoreWorker do
  @moduledoc """
  Oban worker that computes and records deal scores for all vehicles
  with recent price snapshots. Runs daily via cron.

  This worker acts as an enqueuer. For each vehicle with snapshots
  in the last 7 days, it enqueues a ScoreVehicleWorker job.
  """
  use Oban.Worker, queue: :default, max_attempts: 2

  require Logger
  alias Elcamlot.Repo
  alias Elcamlot.Vehicles.{Vehicle, PriceSnapshot}
  alias Elcamlot.Workers.ScoreVehicleWorker

  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    vehicles = vehicles_with_recent_snapshots()

    Logger.info("DealScoreWorker: enqueuing scoring jobs for #{length(vehicles)} vehicles")

    vehicles
    |> Enum.map(fn vehicle ->
      %{vehicle_id: vehicle.id}
      |> ScoreVehicleWorker.new()
    end)
    |> Oban.insert_all()

    :ok
  end

  defp vehicles_with_recent_snapshots do
    seven_days_ago = DateTime.add(DateTime.utc_now(), -7, :day)

    from(v in Vehicle,
      join: p in PriceSnapshot,
      on: p.vehicle_id == v.id,
      where: p.time >= ^seven_days_ago,
      distinct: v.id
    )
    |> Repo.all()
  end
end
