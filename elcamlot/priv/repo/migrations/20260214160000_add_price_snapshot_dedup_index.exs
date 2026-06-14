defmodule Elcamlot.Repo.Migrations.AddPriceSnapshotDedupIndex do
  use Ecto.Migration

  def up do
    # Remove existing duplicates before adding unique constraint
    # Keep the first entry (by ctid) for each (vehicle_id, url, time) group
    execute("""
    DELETE FROM price_snapshots a USING price_snapshots b
    WHERE a.ctid > b.ctid
      AND a.vehicle_id = b.vehicle_id
      AND a.url = b.url
      AND a.price_cents = b.price_cents
      AND a.time = b.time
    """)

    # TimescaleDB requires the partitioning column (time) in unique indexes
    create unique_index(:price_snapshots, [
      :vehicle_id,
      :url,
      :price_cents,
      :time
    ], name: :price_snapshots_vehicle_url_time_idx)
  end

  def down do
    drop_if_exists index(:price_snapshots, [:vehicle_id, :url, :time],
      name: :price_snapshots_vehicle_url_time_idx)
  end
end
