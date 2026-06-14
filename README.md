# Elcamlot

Multi-domain analytics platform built with Elixir/Phoenix and OCaml. Tracks financial markets and vehicle prices, runs statistical analysis, and surfaces cross-domain correlations.

## Architecture

```
Phoenix Web App (host)
├── LiveView dashboards (finance, vehicles, cross-analytics)
├── Alpaca Markets SDK (equities data)
├── Brave Search API (vehicle listings)
├── Ecto → Postgres (OLTP + time-series)
├── Oban (scheduled jobs, market data polling)
├── WebSocket streaming (real-time bars via Alpaca)
└── HTTP client → OCaml Analytics

OCaml Analytics Service (Incus or Docker container)
├── REST API (Dream framework)
├── Financial: volatility, correlation, returns, moving averages, momentum/RSI
├── Advanced: Monte Carlo simulation, Bayesian estimation, buy timing
├── Vehicle: deal scoring, depreciation curves, outlier detection
├── General: data quality grading, histogram/distribution analysis
└── 15 POST endpoints + health check

Postgres + TimescaleDB + pg_duckdb (Incus or Docker container)
├── Financial instruments + price bars (hypertable)
├── Vehicles + price snapshots (hypertable)
├── Users, saved searches, price alerts
├── Materialized views for market stats
└── pg_duckdb for bulk CSV/Parquet ingest
```

## Features

**Financial Markets**
- Real-time equity streaming via Alpaca WebSocket (1-min bars, IEX feed)
- Crypto polling every 15 min (BTC/USD, ETH/USD) — 24/7 data collection
- Historical daily bars + 5-min intraday backfill (30 days)
- Volatility, correlation, returns, moving averages, momentum/RSI analysis
- Monte Carlo simulation, Bayesian estimation, optimal buy timing
- Instrument dashboard with Chart.js visualizations

**Vehicle Price Intelligence**
- Web search via Brave Search API with rate limiting
- Price tracking over time with TimescaleDB
- Deal scoring, depreciation curves, outlier detection
- Saved searches with scheduled re-scraping (Oban)

**Cross-Domain Analytics**
- Compare vehicle depreciation against stock/index performance
- Pearson correlation with dual-axis Chart.js overlay
- pg_duckdb bulk ingest + cross-domain SQL queries
- Monthly trend analysis across asset classes

**Platform**
- User auth with scoped sessions (bcrypt + tokens)
- Watchlists with configurable price drop alerts
- Dark/light theme with DaisyUI
- CSV export for vehicles and instruments
- Shareable read-only views via time-limited tokens
- Side-by-side vehicle comparison (2-4 at once)
- 45+ justfile tasks for dev workflow

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Web | Elixir 1.19 / Phoenix 1.8 / LiveView 1.1 |
| Analytics | OCaml 5.x + Dream |
| Database | Postgres 16 + TimescaleDB + pg_duckdb |
| Market data | Alpaca Markets (alpa_ex SDK) |
| Search | Brave Search API |
| Jobs | Oban (Asynchronously decoupled workers) |
| Containers | Incus / Docker (for macOS/cross-platform) |

## Quick Start

```bash
# Provision containers and start everything (auto-detects Docker/Incus)
bash scripts/dev.sh

# Or step by step via justfile tasks (auto-fallbacks to Docker if Incus is missing)
just pg-up              # Postgres + TimescaleDB
just ocaml-up           # OCaml analytics service
just ocaml-deploy       # Push + build analytics
just ocaml-start        # Start analytics daemon
just migrate            # Run Ecto migrations
just server             # Start Phoenix
```

## Project Structure

```
elcamlot/
├── elcamlot/           # Phoenix application
│   ├── lib/elcamlot/   # Contexts (Markets, Vehicles, Watchlist, Accounts)
│   └── lib/elcamlot_web/  # LiveViews, controllers, components
├── analytics/          # OCaml analytics service
│   ├── lib/            # Analysis modules (15 total)
│   └── bin/            # Dream HTTP server
├── infra/              # Incus provisioning, SQL scripts
├── scripts/            # Dev workflow
└── justfile            # Task runner (40+ commands)
```

## Useful Commands

```bash
just ps                 # Container status
just info               # Connection URLs
just console            # Phoenix iex console
just test               # Run tests
just ocaml-health       # Test analytics API
just alpaca-seed-batch  # Seed 7 symbols with daily bars
just backfill-intraday  # Backfill 30 days of 5-min bars
just stream-status      # Check WebSocket stream status
just cross-analysis     # Run cross-domain analytical queries
just export-bars        # Export price_bars to CSV
just versions           # Check all tool versions
```
