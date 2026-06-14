defmodule Elcamlot.MarketDataStream do
  @moduledoc """
  GenServer that connects to Alpaca's real-time market data stream via WebSocket.
  Subscribes to minute bars for configured equity symbols and upserts them into price_bars.

  Uses the free IEX feed on paper trading. Bars only arrive during market hours
  (9:30-16:00 ET, Mon-Fri), so we keep the connection alive 24/7 — no harm in idle time.
  """
  use GenServer
  require Logger

  alias Elcamlot.{Alpaca, Markets}

  @symbols ~w(AAPL MSFT GOOGL AMZN TSLA SPY QQQ)
  @timeframe "1Min"

  # --- Public API ---

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  # --- Callbacks ---

  @impl true
  def init(_opts) do
    # Don't connect if API keys are missing
    case {api_key(), api_secret()} do
      {"", _} ->
        Logger.info("MarketDataStream: No APCA_API_KEY_ID set, skipping stream")
        {:ok, %{stream_pid: nil, connected: false, bars_received: 0}}

      {_, ""} ->
        Logger.info("MarketDataStream: No APCA_API_SECRET_KEY set, skipping stream")
        {:ok, %{stream_pid: nil, connected: false, bars_received: 0}}

      _ ->
        send(self(), :connect)
        {:ok, %{stream_pid: nil, connected: false, bars_received: 0}}
    end
  end

  @impl true
  def handle_info(:connect, state) do
    callback = fn event -> GenServer.cast(__MODULE__, {:bar_event, event}) end

    stream_opts = [
      callback: callback,
      feed: "iex",
      api_key: api_key(),
      api_secret: api_secret()
    ]

    case Alpa.Stream.MarketData.start_link(stream_opts) do
      {:ok, pid} ->
        Logger.info("MarketDataStream: Connected to Alpaca stream")
        Alpa.Stream.MarketData.subscribe(pid, bars: @symbols)
        Logger.info("MarketDataStream: Subscribed to bars for #{Enum.join(@symbols, ", ")}")
        {:noreply, %{state | stream_pid: pid, connected: true}}

      {:error, reason} ->
        Logger.warning("MarketDataStream: Failed to connect — #{inspect(reason)}, retrying in 30s")
        Process.send_after(self(), :connect, 30_000)
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:bar_event, %{type: :bar, data: bar}}, state) do
    Task.Supervisor.async_nolink(Elcamlot.TaskSupervisor, fn ->
      store_bar(bar)
    end)

    {:noreply, %{state | bars_received: state.bars_received + 1}}
  end

  def handle_cast({:bar_event, _other}, state) do
    # Ignore non-bar events (connection status, etc.)
    {:noreply, state}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, Map.take(state, [:connected, :bars_received, :stream_pid]), state}
  end

  # --- Private ---

  defp store_bar(bar) do
    symbol = bar.symbol

    case Markets.get_instrument_by_symbol(symbol) do
      nil ->
        case Markets.upsert_instrument(%{symbol: symbol, asset_class: "us_equity"}) do
          {:ok, instrument} -> do_upsert(bar, instrument.id)
          {:error, reason} -> Logger.warning("MarketDataStream: Failed to upsert instrument #{symbol}: #{inspect(reason)}")
        end

      instrument ->
        do_upsert(bar, instrument.id)
    end
  end

  defp do_upsert(bar, instrument_id) do
    row = Alpaca.bar_to_row(bar, instrument_id, @timeframe)
    
    case Markets.upsert_bars([row]) do
      {_count, nil} -> :ok
      other -> Logger.warning("MarketDataStream: Upsert bar result: #{inspect(other)}")
    end
  end

  defp api_key, do: Application.get_env(:elcamlot, :alpaca_api_key, System.get_env("APCA_API_KEY_ID", ""))
  defp api_secret, do: Application.get_env(:elcamlot, :alpaca_api_secret, System.get_env("APCA_API_SECRET_KEY", ""))
end
