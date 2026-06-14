defmodule Elcamlot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElcamlotWeb.Telemetry,
      Elcamlot.Repo,
      {DNSCluster, query: Application.get_env(:elcamlot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Elcamlot.PubSub},
      # Job processing
      {Oban, Application.fetch_env!(:elcamlot, Oban)},
      # Background workers
      Elcamlot.BraveSearch.Throttler,
      Elcamlot.MarketStatsRefresher,
      # Real-time market data stream (Alpaca WebSocket)
      {Task.Supervisor, name: Elcamlot.TaskSupervisor},
      Elcamlot.MarketDataStream,
      # Start to serve requests, typically the last entry
      ElcamlotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elcamlot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElcamlotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
