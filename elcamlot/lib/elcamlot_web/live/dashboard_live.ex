defmodule ElcamlotWeb.DashboardLive do
  use ElcamlotWeb, :live_view

  require Logger
  alias Elcamlot.{Vehicles, Analytics, MarketAnalytics, Watchlist}

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    vehicle = Vehicles.get_vehicle!(id)
    snapshots = Vehicles.list_price_snapshots(vehicle.id)
    stats = Vehicles.price_stats(vehicle.id)

    dom_stats = Vehicles.days_on_market_stats(vehicle.id)
    score_history = Vehicles.deal_score_history(vehicle.id)
    latest_score = Vehicles.latest_deal_score(vehicle.id)
    score_trend = compute_score_trend(score_history)

    socket =
      socket
      |> assign(:vehicle, vehicle)
      |> assign(:snapshots, snapshots)
      |> assign(:stats, stats)
      |> assign(:dom_stats, dom_stats)
      |> assign(:score_history, score_history)
      |> assign(:latest_score, latest_score)
      |> assign(:score_trend, score_trend)
      |> assign(:searching, false)
      |> assign(:share_link, nil)
      |> assign(:alert_form, to_form(%{"target_price" => "", "alert_type" => "below"}))
      |> start_async_analytics(vehicle.id, snapshots)

    {:ok, socket}
  end

  @impl true
  def handle_event("create-share-link", _params, socket) do
    vehicle = socket.assigns.vehicle
    token = ElcamlotWeb.ShareController.generate_token(vehicle.id)
    url = ElcamlotWeb.Endpoint.url() <> "/share/#{token}"
    {:noreply, assign(socket, :share_link, url)}
  end

  def handle_event("refresh-prices", _params, socket) do
    vehicle = socket.assigns.vehicle
    query = "#{vehicle.year} #{vehicle.make} #{vehicle.model} price for sale"

    socket = assign(socket, searching: true)
    send(self(), {:do_search, query})
    {:noreply, socket}
  end

  def handle_event("set-alert", %{"target_price" => price_str, "alert_type" => alert_type}, socket) do
    user = socket.assigns.current_scope.user
    vehicle = socket.assigns.vehicle

    case Integer.parse(price_str) do
      {dollars, _} when dollars > 0 ->
        case Watchlist.create_alert(%{
               user_id: user.id,
               vehicle_id: vehicle.id,
               target_price_cents: dollars * 100,
               alert_type: alert_type
             }) do
          {:ok, _alert} ->
            {:noreply,
             socket
             |> assign(:alert_form, to_form(%{"target_price" => "", "alert_type" => "below"}))
             |> put_flash(:info, "Price alert set for $#{dollars}")}

          {:error, _} ->
            {:noreply, put_flash(socket, :error, "Failed to create alert")}
        end

      _ ->
        {:noreply, put_flash(socket, :error, "Enter a valid dollar amount")}
    end
  end

  @impl true
  def handle_info({:do_search, query}, socket) do
    vehicle = socket.assigns.vehicle

    case Elcamlot.BraveSearch.search_cars(query) do
      {:ok, results} ->
        Enum.each(results, fn result ->
          Vehicles.create_price_snapshot(%{
            time: DateTime.utc_now(),
            vehicle_id: vehicle.id,
            price_cents: result.price_cents,
            mileage: result.mileage,
            source: result.source,
            url: result.url
          })
        end)

        snapshots = Vehicles.list_price_snapshots(vehicle.id)
        stats = Vehicles.price_stats(vehicle.id)
        dom_stats = Vehicles.days_on_market_stats(vehicle.id)
        score_history = Vehicles.deal_score_history(vehicle.id)
        latest_score = Vehicles.latest_deal_score(vehicle.id)
        score_trend = compute_score_trend(score_history)

        socket =
          socket
          |> assign(
            snapshots: snapshots,
            stats: stats,
            dom_stats: dom_stats,
            score_history: score_history,
            latest_score: latest_score,
            score_trend: score_trend,
            searching: false
          )
          |> start_async_analytics(vehicle.id, snapshots)
          |> put_flash(:info, "Added #{length(results)} price points")

        {:noreply, socket}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(searching: false)
         |> put_flash(:error, "Search failed: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_info({_task_ref, {key, value}}, socket) when key in [:depreciation, :market_position, :deal_scores, :data_quality, :outliers] do
    {:noreply, assign(socket, key, value)}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, socket) do
    {:noreply, socket}
  end

  defp start_async_analytics(socket, vehicle_id, snapshots) do
    if connected?(socket) do
      prices = Enum.map(snapshots, & &1.price_cents)
      Task.async(fn -> {:depreciation, fetch_depreciation(snapshots)} end)
      Task.async(fn -> {:market_position, fetch_market_position(vehicle_id)} end)
      Task.async(fn -> {:deal_scores, fetch_deal_scores(snapshots, vehicle_id)} end)
      Task.async(fn -> {:data_quality, fetch_data_quality(prices)} end)
      Task.async(fn -> {:outliers, fetch_outliers(prices)} end)
    end

    socket
    |> assign(:depreciation, nil)
    |> assign(:market_position, nil)
    |> assign(:deal_scores, %{})
    |> assign(:data_quality, nil)
    |> assign(:outliers, nil)
  end

  defp fetch_market_position(vehicle_id) do
    MarketAnalytics.vehicle_market_position(vehicle_id)
  rescue
    e in [Postgrex.Error, DBConnection.ConnectionError] ->
      Logger.debug("Market query failed: #{Exception.message(e)}")
      nil
  end

  defp fetch_deal_scores(snapshots, _vehicle_id) when length(snapshots) < 3, do: %{}

  defp fetch_deal_scores(snapshots, vehicle_id) do
    market_prices = Vehicles.get_market_prices(vehicle_id)

    snapshots
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {snap, idx}, acc ->
      case Analytics.deal_score(snap.price_cents, market_prices) do
        {:ok, result} -> Map.put(acc, idx, result)
        _ -> acc
      end
    end)
  rescue
    e in [Req.TransportError, Req.HTTPError] ->
      Logger.debug("Deal scoring unavailable: #{Exception.message(e)}")
      %{}
  end

  defp fetch_depreciation(snapshots) when length(snapshots) < 2, do: nil

  defp fetch_depreciation(snapshots) do
    case Analytics.depreciation(snapshots) do
      {:ok, data} -> data
      {:error, _} -> nil
    end
  rescue
    e in [Req.TransportError, Req.HTTPError] ->
      Logger.debug("Depreciation service unavailable: #{Exception.message(e)}")
      nil
  end

  defp fetch_data_quality(prices) when length(prices) < 3, do: nil

  defp fetch_data_quality(prices) do
    case Analytics.data_quality(prices) do
      {:ok, data} -> data
      {:error, _} -> nil
    end
  rescue
    e in [Req.TransportError, Req.HTTPError] ->
      Logger.debug("Data quality unavailable: #{Exception.message(e)}")
      nil
  end

  defp fetch_outliers(prices) when length(prices) < 3, do: nil

  defp fetch_outliers(prices) do
    case Analytics.outliers(prices) do
      {:ok, data} -> data
      {:error, _} -> nil
    end
  rescue
    e in [Req.TransportError, Req.HTTPError] ->
      Logger.debug("Outlier detection unavailable: #{Exception.message(e)}")
      nil
  end

  defp compute_score_trend(history) when length(history) < 2, do: :stable

  defp compute_score_trend(history) do
    recent = Enum.take(history, -5)
    first_score = hd(recent).score
    last_score = List.last(recent).score
    diff = last_score - first_score

    cond do
      diff > 3.0 -> :improving
      diff < -3.0 -> :declining
      true -> :stable
    end
  end

  defp trend_label(:improving), do: {"Improving", "text-success"}
  defp trend_label(:declining), do: {"Declining", "text-error"}
  defp trend_label(:stable), do: {"Stable", "text-info"}

  defp trend_arrow(:improving), do: "^"
  defp trend_arrow(:declining), do: "v"
  defp trend_arrow(:stable), do: "~"

  defp score_chart_data(score_history) do
    Enum.map(score_history, fn ds ->
      %{
        computed_at: DateTime.to_iso8601(ds.computed_at),
        score: ds.score
      }
    end)
  end

  defp freshness_class(days) when is_integer(days) do
    cond do
      days >= 60 -> {"Stale", "bg-error/10 text-error"}
      days >= 30 -> {"Negotiable", "bg-warning/10 text-warning"}
      days >= 14 -> {"Sitting", "bg-info/10 text-info"}
      true -> {"Fresh", "bg-success/10 text-success"}
    end
  end

  defp freshness_class(_), do: {"---", ""}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto px-4 py-8">
      <.link navigate={~p"/"} class="text-primary hover:underline text-sm">&larr; Back to search</.link>

      <div class="mt-4 mb-8">
        <div class="flex items-start justify-between">
          <div>
            <h1 class="text-3xl font-bold">
              {@vehicle.year} {@vehicle.make} {@vehicle.model}
            </h1>
            <p :if={@vehicle.trim} class="text-base-content/60">{@vehicle.trim}</p>
          </div>
          <div class="flex gap-2 mt-1">
            <a
              href={~p"/export/vehicles/#{@vehicle.id}/csv"}
              class="bg-base-200 hover:bg-base-300 text-base-content px-3 py-1.5 rounded text-sm"
            >
              Export CSV
            </a>
            <button
              phx-click="create-share-link"
              class="bg-base-200 hover:bg-base-300 text-base-content px-3 py-1.5 rounded text-sm"
            >
              Share
            </button>
          </div>
        </div>

        <div :if={@share_link} class="mt-3 p-3 bg-info/10 rounded-lg text-sm">
          <div class="text-base-content/60 mb-1">Share this link (valid for 7 days):</div>
          <div class="flex items-center gap-2">
            <input
              type="text"
              value={@share_link}
              readonly
              class="input input-bordered input-sm flex-1 font-mono text-xs"
            />
          </div>
        </div>
      </div>

      <%!-- Stats Cards --%>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-base-100 rounded-lg shadow p-4">
          <div class="text-sm text-base-content/60">Avg Price</div>
          <div class="text-2xl font-bold">{format_price(@stats["avg_price"])}</div>
        </div>
        <div class="bg-base-100 rounded-lg shadow p-4">
          <div class="text-sm text-base-content/60">Median</div>
          <div class="text-2xl font-bold">{format_price(@stats["median"])}</div>
        </div>
        <div class="bg-base-100 rounded-lg shadow p-4">
          <div class="text-sm text-base-content/60">Min Price</div>
          <div class="text-2xl font-bold text-success">{format_price(@stats["min_price"])}</div>
        </div>
        <div class="bg-base-100 rounded-lg shadow p-4">
          <div class="text-sm text-base-content/60">Max Price</div>
          <div class="text-2xl font-bold text-error">{format_price(@stats["max_price"])}</div>
        </div>
      </div>

      <%!-- Distribution Stats --%>
      <div :if={@stats["count"] > 2} class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <h2 class="text-lg font-semibold mb-4">Price Distribution</h2>
        <div class="grid grid-cols-2 md:grid-cols-6 gap-4 text-sm">
          <div>
            <span class="text-base-content/60">Std Dev</span>
            <div class="font-mono">{format_price(@stats["std_dev"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">IQR</span>
            <div class="font-mono">{format_price(@stats["iqr"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">P10</span>
            <div class="font-mono">{format_price(@stats["p10"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">P25</span>
            <div class="font-mono">{format_price(@stats["p25"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">P75</span>
            <div class="font-mono">{format_price(@stats["p75"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">P90</span>
            <div class="font-mono">{format_price(@stats["p90"])}</div>
          </div>
        </div>
        <div class="mt-2 text-xs text-base-content/40">{@stats["count"]} data points</div>
      </div>

      <%!-- Market Comparison (from pg_duckdb) --%>
      <div :if={@market_position} class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <h2 class="text-lg font-semibold mb-4">Market Comparison</h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div>
            <div class="text-sm text-base-content/60">Your Avg</div>
            <div class="text-xl font-bold">{format_price(@market_position["vehicle_avg_price"])}</div>
          </div>
          <div>
            <div class="text-sm text-base-content/60">Market Avg</div>
            <div class="text-xl font-bold">{format_price(@market_position["market_avg"])}</div>
          </div>
          <div>
            <div class="text-sm text-base-content/60">Z-Score</div>
            <div class="text-xl font-bold">
              {if z = @market_position["z_score"], do: "#{z}", else: "---"}
            </div>
            <div class="text-xs text-base-content/60">
              <%= cond do %>
                <% (@market_position["z_score"] || 0) < -1 -> %>
                  Well below market
                <% (@market_position["z_score"] || 0) > 1 -> %>
                  Well above market
                <% true -> %>
                  Near market average
              <% end %>
            </div>
          </div>
          <div>
            <div class="text-sm text-base-content/60">Market Size</div>
            <div class="text-xl font-bold">{@market_position["market_count"]} listings</div>
          </div>
        </div>
        <div class="mt-3 text-right">
          <.link navigate={~p"/market"} class="text-primary hover:underline text-sm">
            View full market analytics &rarr;
          </.link>
        </div>
      </div>

      <%!-- Depreciation (from OCaml service) --%>
      <div :if={@depreciation} class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <h2 class="text-lg font-semibold mb-4">
          Depreciation Curve
          <span :if={@depreciation["model"]} class="text-xs font-normal text-base-content/40 ml-2">
            ({@depreciation["model"]} model, R²={@depreciation["r_squared"]})
          </span>
        </h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm mb-4">
          <div>
            <span class="text-base-content/60">Annual Depreciation</span>
            <div class="text-xl font-bold text-warning">{@depreciation["annual_depreciation_pct"]}%</div>
          </div>
          <div>
            <span class="text-base-content/60">Estimated Initial Price</span>
            <div class="font-mono">{format_price(@depreciation["initial_price"])}</div>
          </div>
          <div>
            <span class="text-base-content/60">Data Points Used</span>
            <div class="font-mono">{@depreciation["data_points"]}</div>
          </div>
          <div :if={@depreciation["alt_r_squared"]}>
            <span class="text-base-content/60">Alt Model R²</span>
            <div class="font-mono text-base-content/40">{@depreciation["alt_r_squared"]}</div>
          </div>
        </div>
        <div :if={@depreciation["predictions"]} class="border-t pt-4">
          <h3 class="text-sm font-medium text-base-content/60 mb-2">Predicted Future Prices</h3>
          <div class="flex gap-4">
            <%= for pred <- @depreciation["predictions"] do %>
              <div class="bg-base-200 rounded px-3 py-2 text-center">
                <div class="text-xs text-base-content/60">+{pred["years_from_now"]}yr</div>
                <div class="font-mono font-bold">{format_price(pred["predicted_price"])}</div>
              </div>
            <% end %>
          </div>
        </div>
      </div>

      <%!-- Data Quality + Outliers row --%>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
        <div :if={@data_quality} class="bg-base-100 rounded-lg shadow p-6">
          <h2 class="text-lg font-semibold mb-3">
            Data Quality
            <span class={[
              "ml-2 text-2xl font-bold",
              if(@data_quality["grade"] in ~w(A B), do: "text-success",
                else: if(@data_quality["grade"] == "C", do: "text-warning", else: "text-error"))
            ]}>
              {@data_quality["grade"]}
            </span>
            <span class="text-xs text-base-content/40 font-normal ml-1">
              ({@data_quality["composite_score"]}/100)
            </span>
          </h2>
          <div class="grid grid-cols-2 gap-3 text-sm">
            <div>
              <span class="text-base-content/60">Sample Size</span>
              <div class="font-mono">{@data_quality["sample_size"]} pts ({@data_quality["dimensions"]["sample_size_score"] |> trunc()}%)</div>
            </div>
            <div>
              <span class="text-base-content/60">Spread (CV)</span>
              <div class="font-mono">{@data_quality["details"]["cv"]} ({@data_quality["dimensions"]["spread_score"] |> trunc()}%)</div>
            </div>
            <div>
              <span class="text-base-content/60">Skewness</span>
              <div class="font-mono">{@data_quality["details"]["skewness"]}</div>
            </div>
            <div>
              <span class="text-base-content/60">Kurtosis</span>
              <div class="font-mono">{@data_quality["details"]["kurtosis"]}</div>
            </div>
          </div>
        </div>

        <div :if={@outliers} class="bg-base-100 rounded-lg shadow p-6">
          <h2 class="text-lg font-semibold mb-3">
            Outlier Detection
            <span class="text-xs text-base-content/40 font-normal ml-1">
              ({@outliers["outlier_count"]} of {@outliers["total_count"]} flagged)
            </span>
          </h2>
          <%= if @outliers["outlier_count"] > 0 do %>
            <div class="space-y-2">
              <%= for flag <- @outliers["flagged"] do %>
                <div class="flex items-center gap-3 text-sm">
                  <span class={[
                    "px-2 py-0.5 rounded-full text-xs font-medium",
                    if(flag["severity"] == "extreme", do: "bg-error/20 text-error",
                      else: if(flag["severity"] == "high", do: "bg-warning/20 text-warning",
                        else: "bg-info/10 text-info"))
                  ]}>
                    {flag["severity"]}
                  </span>
                  <span class="font-mono">{format_price(flag["price"])}</span>
                  <span class="text-base-content/40">z={flag["z_score"]} ({flag["method"]})</span>
                </div>
              <% end %>
            </div>
          <% else %>
            <p class="text-sm text-success">No outliers detected -- data looks clean.</p>
          <% end %>
          <div class="mt-3 text-xs text-base-content/40">
            IQR bounds: {format_price(@outliers["thresholds"]["iqr_lower"])} -- {format_price(@outliers["thresholds"]["iqr_upper"])}
          </div>
        </div>
      </div>

      <%!-- Deal Score History --%>
      <div :if={@score_history != []} class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-lg font-semibold">
            Deal Score History
            <% {trend_text, trend_class} = trend_label(@score_trend) %>
            <span class={"ml-2 text-sm font-normal #{trend_class}"}>
              {trend_arrow(@score_trend)} {trend_text}
            </span>
          </h2>
          <div :if={@latest_score} class="text-right">
            <div class="text-sm text-base-content/60">Current Score</div>
            <div class={[
              "text-2xl font-bold",
              cond do
                @latest_score.score >= 70 -> "text-success"
                @latest_score.score >= 40 -> "text-warning"
                true -> "text-error"
              end
            ]}>
              {Float.round(@latest_score.score, 1)}
            </div>
          </div>
        </div>

        <div
          id="deal-score-chart"
          phx-hook="DealScoreChart"
          phx-update="ignore"
          data-scores={Jason.encode!(score_chart_data(@score_history))}
          class="mb-4 h-48"
        >
          <canvas></canvas>
        </div>

        <div :if={@latest_score} class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm border-t pt-4">
          <div>
            <span class="text-base-content/60">Vehicle Price</span>
            <div class="font-mono font-bold">{format_price(@latest_score.vehicle_price_cents)}</div>
          </div>
          <div>
            <span class="text-base-content/60">Market Avg</span>
            <div class="font-mono">{format_price(@latest_score.market_avg_cents)}</div>
          </div>
          <div>
            <span class="text-base-content/60">Percentile</span>
            <div class="font-mono">
              {if @latest_score.percentile_rank, do: "#{Float.round(@latest_score.percentile_rank, 1)}%", else: "---"}
            </div>
          </div>
          <div>
            <span class="text-base-content/60">Data Points</span>
            <div class="font-mono">{length(@score_history)} scores</div>
          </div>
        </div>
      </div>

      <%!-- Days on Market --%>
      <div :if={@dom_stats != []} class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <h2 class="text-lg font-semibold mb-4">Listing Freshness</h2>
        <div class="space-y-2">
          <%= for listing <- Enum.take(@dom_stats, 15) do %>
            <% {label, badge_class} = freshness_class(listing["days_on_market"]) %>
            <div class="flex items-center gap-3 text-sm">
              <span class={"inline-block w-20 text-center px-2 py-0.5 rounded-full text-xs font-medium #{badge_class}"}>
                {label}
              </span>
              <span class="font-mono w-16 text-right">{listing["days_on_market"]}d</span>
              <span class="font-mono font-bold">{format_price(listing["min_price"])}</span>
              <%= if listing["times_seen"] > 1 do %>
                <span class="text-base-content/40">seen {listing["times_seen"]}x</span>
              <% end %>
              <a :if={listing["url"]} href={listing["url"]} target="_blank" class="text-primary hover:underline ml-auto truncate max-w-xs">
                {URI.parse(listing["url"]).host |> String.replace(~r/^www\./, "")}
              </a>
            </div>
          <% end %>
        </div>
      </div>

      <%!-- Price Alert --%>
      <div class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <h2 class="text-lg font-semibold mb-3">Set Price Alert</h2>
        <.form for={@alert_form} phx-submit="set-alert" class="flex gap-3 items-end">
          <div>
            <label class="text-sm text-base-content/60 block mb-1">Target Price ($)</label>
            <input
              type="number"
              name="target_price"
              value={@alert_form[:target_price].value}
              placeholder="25000"
              min="1"
              class="input input-bordered input-sm w-32"
              required
            />
          </div>
          <div>
            <label class="text-sm text-base-content/60 block mb-1">When</label>
            <select name="alert_type" class="select select-bordered select-sm">
              <option value="below">Price drops below</option>
              <option value="above">Price goes above</option>
            </select>
          </div>
          <button
            type="submit"
            class="bg-primary text-primary-content px-4 py-1.5 rounded text-sm hover:bg-primary/80"
          >
            Set Alert
          </button>
        </.form>
      </div>

      <%!-- Price History --%>
      <div class="bg-base-100 rounded-lg shadow p-6 mb-8">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-lg font-semibold">Price History</h2>
          <button
            phx-click="refresh-prices"
            disabled={@searching}
            class="bg-primary text-primary-content px-4 py-1.5 rounded text-sm hover:bg-primary/80 disabled:opacity-50"
          >
            <%= if @searching, do: "Fetching...", else: "Fetch New Prices" %>
          </button>
        </div>

        <%!-- Price chart (Chart.js) --%>
        <div
          :if={@snapshots != []}
          id="price-chart"
          phx-hook="PriceChart"
          phx-update="ignore"
          data-snapshots={Jason.encode!(Enum.map(@snapshots, fn s -> %{time: s.time, price: div(s.price_cents, 100)} end))}
          class="mb-6 h-64"
        >
          <canvas></canvas>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead>
              <tr class="border-b text-left text-base-content/60">
                <th class="py-2 pr-4">Date</th>
                <th class="py-2 pr-4">Price</th>
                <th class="py-2 pr-4">Mileage</th>
                <th class="py-2 pr-4">Source</th>
                <th class="py-2 pr-4">Deal</th>
                <th class="py-2">Link</th>
              </tr>
            </thead>
            <tbody>
              <%= for {snap, idx} <- Enum.take(@snapshots, 25) |> Enum.with_index() do %>
                <tr class="border-b hover:bg-base-200">
                  <td class="py-2 pr-4 text-base-content/60">{format_date(snap.time)}</td>
                  <td class="py-2 pr-4 font-mono font-bold">{format_price(snap.price_cents)}</td>
                  <td class="py-2 pr-4">
                    <%= if snap.mileage do %>
                      {snap.mileage |> Integer.to_string() |> format_number()} mi
                    <% else %>
                      ---
                    <% end %>
                  </td>
                  <td class="py-2 pr-4">{snap.source || "---"}</td>
                  <td class="py-2 pr-4">
                    <% deal = @deal_scores[idx] %>
                    <span
                      :if={deal}
                      class={[
                        "inline-block px-2 py-0.5 rounded-full text-xs font-medium",
                        deal_badge_class(deal["label"])
                      ]}
                    >
                      {deal["label"]} ({deal["score"]})
                    </span>
                  </td>
                  <td class="py-2">
                    <a :if={snap.url} href={snap.url} target="_blank" class="text-primary hover:underline">
                      View &rarr;
                    </a>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end
end
