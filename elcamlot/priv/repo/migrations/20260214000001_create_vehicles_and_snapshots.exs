defmodule Elcamlot.Repo.Migrations.CreateVehiclesAndSnapshots do
  use Ecto.Migration

  def up do
    # TimescaleDB extension
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create_if_not_exists table(:vehicles) do
      add :make, :string, null: false
      add :model, :string, null: false
      add :year, :integer, null: false
      add :trim, :string

      add :created_at, :utc_datetime, null: false, default: fragment("now()")
    end

    create_if_not_exists(unique_index(:vehicles, [:make, :model, :year, :trim]))
    create_if_not_exists(index(:vehicles, [:make, :model]))
    create_if_not_exists(index(:vehicles, [:year]))

    create_if_not_exists table(:price_snapshots, primary_key: false) do
      add :time, :utc_datetime, null: false
      add :vehicle_id, references(:vehicles), null: false
      add :price_cents, :bigint, null: false
      add :mileage, :integer
      add :source, :string
      add :location, :string
      add :url, :text
    end

    create_if_not_exists(index(:price_snapshots, [:vehicle_id]))
    create_if_not_exists(index(:price_snapshots, [:source]))

    # Convert to TimescaleDB hypertable
    execute("SELECT create_hypertable('price_snapshots', 'time', if_not_exists => TRUE)")

    create_if_not_exists table(:search_queries) do
      add :query, :text, null: false
      add :filters, :map
      add :result_count, :integer
      add :searched_at, :utc_datetime, default: fragment("now()")
    end
  end

  def down do
    drop_if_exists(table(:search_queries))
    drop_if_exists(table(:price_snapshots))
    drop_if_exists(table(:vehicles))
  end
end
