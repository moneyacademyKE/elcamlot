# Elcamlot — common development tasks

# Default: show available commands
default:
    @just --list

# --- Infrastructure ---

# Provision Postgres container (idempotent)
pg-up:
    bash infra/setup-pg.sh

# Provision OCaml analytics container (idempotent)
ocaml-up:
    bash infra/setup-ocaml.sh

# Start all containers
up: pg-up ocaml-up

# Stop all project containers
down:
    bash infra/teardown.sh

# Show container status
ps:
    @if command -v incus &>/dev/null; then \
        incus list -c ns4t --format table | grep -E "elcamlot|NAME"; \
    else \
        docker ps -a --filter name=elcamlot- --format "table {{.Names}}\t{{.State}}\t{{.Ports}}"; \
    fi

# Get Postgres container IP
pg-ip:
    @if command -v incus &>/dev/null; then \
        incus list elcamlot-pg --format csv -c 4 | cut -d' ' -f1; \
    else \
        ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elcamlot-pg); \
        echo "${ip:-127.0.0.1}"; \
    fi

# Get OCaml container IP
ocaml-ip:
    @if command -v incus &>/dev/null; then \
        incus list elcamlot-ocaml --format csv -c 4 | cut -d' ' -f1; \
    else \
        ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elcamlot-ocaml); \
        echo "${ip:-127.0.0.1}"; \
    fi

# Connect to Postgres via psql
psql:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot; \
    else \
        docker exec -it elcamlot-pg psql -U elcamlot -d elcamlot; \
    fi

# Shell into Postgres container
pg-shell:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-pg -- bash; \
    else \
        docker exec -it elcamlot-pg bash; \
    fi

# Shell into OCaml container
ocaml-shell:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-ocaml -- bash; \
    else \
        docker exec -it elcamlot-ocaml bash; \
    fi

# --- Phoenix ---

# Start Phoenix dev server
server:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix phx.server

# Start Phoenix with iex
console:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) iex -S mix phx.server

# Run Ecto migrations
migrate:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix ecto.migrate

# Reset database (drop + create + migrate)
db-reset:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix ecto.reset

# Seed vehicles from SQL files
seed:
    @if command -v incus &>/dev/null; then \
        incus file push infra/seed-vehicles.sql elcamlot-pg/tmp/seed.sql; \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -f /tmp/seed.sql; \
    else \
        docker cp infra/seed-vehicles.sql elcamlot-pg:/tmp/seed.sql; \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot -f /tmp/seed.sql; \
    fi

# Seed SUV data
seed-suvs:
    @if command -v incus &>/dev/null; then \
        incus file push infra/seed-suvs.sql elcamlot-pg/tmp/seed-suvs.sql; \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -f /tmp/seed-suvs.sql; \
    else \
        docker cp infra/seed-suvs.sql elcamlot-pg:/tmp/seed-suvs.sql; \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot -f /tmp/seed-suvs.sql; \
    fi

# --- Testing ---

# Run all unit tests
test:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix test --exclude integration

# Run integration tests (launches/destroys containers)
test-integration:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix test --only integration --timeout 120000

# Run all tests
test-all:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix test --timeout 120000

# --- OCaml Analytics ---

# Build OCaml analytics service (inside container)
ocaml-build:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-ocaml -- su - analytics -c 'eval $(/usr/bin/opam env --switch=carscope) && cd ~/app && dune build'; \
    else \
        docker exec elcamlot-ocaml sh -c "eval \$(opam env --switch=carscope) && dune build"; \
    fi

# Run OCaml analytics service (inside container)
ocaml-run:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-ocaml -- su - analytics -c 'eval $(/usr/bin/opam env --switch=carscope) && cd ~/app && dune exec bin/server.exe'; \
    else \
        docker exec elcamlot-ocaml sh -c "eval \$(opam env --switch=carscope) && dune exec bin/server.exe"; \
    fi

# Push analytics source to container and rebuild
ocaml-deploy:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-ocaml -- mkdir -p /home/analytics/app; \
        incus file push -r analytics/ elcamlot-ocaml/home/analytics/app/; \
        incus exec elcamlot-ocaml -- chown -R analytics:analytics /home/analytics/app; \
        just ocaml-build; \
    else \
        docker cp analytics/. elcamlot-ocaml:/home/opam/app/; \
        docker exec elcamlot-ocaml chown -R opam:opam /home/opam/app; \
        just ocaml-build; \
    fi

# Test analytics health endpoint
ocaml-health:
    @curl -s http://$(just ocaml-ip):8080/health | python3 -m json.tool

# Test analytics with sample data
ocaml-test-analyze:
    @curl -s -X POST http://$(just ocaml-ip):8080/analyze \
        -H "Content-Type: application/json" \
        -d '{"prices": [25000, 23500, 27000, 24000, 26500]}' | python3 -m json.tool

# --- Brave Search ---

# Search for a car (usage: just search "2021 Toyota Camry")
search query:
    @source .env && curl -s "https://api.search.brave.com/res/v1/web/search?q={{query}}+price+for+sale&count=10" \
        -H "Accept: application/json" \
        -H "X-Subscription-Token: $BRAVE_SEARCH_API_KEY" | python3 -m json.tool | head -80

# --- Dev Workflow ---

# Full dev startup (containers + Phoenix)
dev:
    bash scripts/dev.sh

# Format Elixir code
fmt:
    cd elcamlot && mix format

# Compile and check for warnings
check:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix compile --warnings-as-errors

# Show project stats
stats:
    @echo "=== Vehicles ===" && \
    (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -t -c "SELECT count(*) FROM vehicles;"; else docker exec elcamlot-pg psql -U elcamlot -d elcamlot -t -c "SELECT count(*) FROM vehicles;"; fi) && \
    echo "=== Price Snapshots ===" && \
    (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -t -c "SELECT count(*) FROM price_snapshots;"; else docker exec elcamlot-pg psql -U elcamlot -d elcamlot -t -c "SELECT count(*) FROM price_snapshots;"; fi) && \
    echo "=== Search Queries ===" && \
    (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -t -c "SELECT count(*) FROM search_queries;"; else docker exec elcamlot-pg psql -U elcamlot -d elcamlot -t -c "SELECT count(*) FROM search_queries;"; fi)

# Show connection info for all services
info:
    @echo "Postgres:  postgres://elcamlot:$${PG_PASSWORD:-elcamlot}@$(just pg-ip):5432/elcamlot"
    @echo "Analytics: http://$(just ocaml-ip):8080"
    @echo "Phoenix:   http://localhost:4000"

# --- Logs & Debug ---

# Tail Postgres logs
pg-logs:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-pg -- tail -f /var/log/postgresql/postgresql-18-main.log; \
    else \
        docker logs -f elcamlot-pg; \
    fi

# View OCaml analytics logs
ocaml-logs:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-ocaml -- cat /tmp/analytics.log 2>/dev/null || echo "No logs yet"; \
    else \
        docker logs elcamlot-ocaml; \
    fi

# Run an arbitrary SQL query
sql query:
    incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -c "{{query}}"

# Show top vehicles by price snapshot count
top-vehicles:
    @just sql "SELECT v.year, v.make, v.model, count(p.*) as snapshots, round(avg(p.price_cents)/100) as avg_price FROM vehicles v LEFT JOIN price_snapshots p ON v.id = p.vehicle_id GROUP BY v.id ORDER BY snapshots DESC LIMIT 15;"

# Show recent price snapshots
recent-prices:
    @just sql "SELECT v.year, v.make, v.model, p.price_cents/100 as price, p.source, p.time FROM price_snapshots p JOIN vehicles v ON v.id = p.vehicle_id ORDER BY p.time DESC LIMIT 20;"

# --- OCaml Analytics Testing ---

# Test deal scoring
ocaml-test-score:
    @curl -s -X POST http://$(just ocaml-ip):8080/deal-score \
        -H "Content-Type: application/json" \
        -d '{"price": 22000, "market_prices": [25000, 23500, 27000, 24000, 26500]}' | python3 -m json.tool

# Test depreciation curve
ocaml-test-depreciation:
    @curl -s -X POST http://$(just ocaml-ip):8080/depreciation \
        -H "Content-Type: application/json" \
        -d '{"history": [{"time":"2023-01-01T00:00:00Z","price":35000},{"time":"2024-01-01T00:00:00Z","price":30000},{"time":"2025-01-01T00:00:00Z","price":26000}]}' | python3 -m json.tool

# Run OCaml analytics as background daemon
ocaml-start:
    incus exec elcamlot-ocaml -- su - analytics -c 'eval $(/usr/bin/opam env --switch=carscope) && cd ~/app && nohup dune exec bin/server.exe > /tmp/analytics.log 2>&1 &'
    @echo "Analytics service started in background"

# Stop OCaml analytics daemon
ocaml-stop:
    incus exec elcamlot-ocaml -- pkill -f server.exe 2>/dev/null || true
    @echo "Analytics service stopped"

# --- Snapshot & Backup ---

# Snapshot the Postgres container
pg-snapshot name="backup":
    incus snapshot create elcamlot-pg {{name}}
    @echo "Created snapshot: {{name}}"

# List Postgres snapshots
pg-snapshots:
    incus info elcamlot-pg | grep -A 50 "Snapshots:"

# Restore Postgres from snapshot
pg-restore name="backup":
    incus snapshot restore elcamlot-pg {{name}}
    @echo "Restored from snapshot: {{name}}"

# --- Versions ---

# Check versions of all tools in the stack
versions:
    @echo "=== Host Tools ==="
    @printf "  Elixir:       " && elixir --version 2>/dev/null | tail -1 || echo "not found"
    @printf "  Erlang/OTP:   " && erl -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().' -noshell 2>/dev/null || echo "not found"
    @printf "  Mix Phoenix:  " && cd elcamlot && mix deps 2>/dev/null | grep "phoenix " | awk '{print $3}' || echo "not found"
    @printf "  Mix LiveView: " && cd elcamlot && mix deps 2>/dev/null | grep "phoenix_live_view" | awk '{print $3}' || echo "not found"
    @printf "  Mix Req:      " && cd elcamlot && mix deps 2>/dev/null | grep "req " | awk '{print $3}' || echo "not found"
    @printf "  Tailwind CSS: " && grep 'version:' elcamlot/config/config.exs | grep tailwind | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo "not found"
    @printf "  esbuild:      " && grep 'version:' elcamlot/config/config.exs | grep esbuild | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo "not found"
    @echo ""
    @echo "=== Containers ==="
    @printf "  PostgreSQL:   " && (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- psql --version 2>/dev/null | awk '{print $3}'; else docker exec elcamlot-pg psql --version 2>/dev/null | awk '{print $3}'; fi) || echo "container not running"
    @printf "  TimescaleDB:  " && (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -t -c "SELECT extversion FROM pg_extension WHERE extname='timescaledb';" 2>/dev/null | tr -d ' '; else docker exec elcamlot-pg psql -U elcamlot -d elcamlot -t -c "SELECT extversion FROM pg_extension WHERE extname='timescaledb';" 2>/dev/null | tr -d ' '; fi) || echo "container not running"
    @printf "  pg_duckdb:    " && (if command -v incus &>/dev/null; then incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -t -c "SELECT extversion FROM pg_extension WHERE extname='pg_duckdb';" 2>/dev/null | tr -d ' '; else docker exec elcamlot-pg psql -U elcamlot -d elcamlot -t -c "SELECT extversion FROM pg_extension WHERE extname='pg_duckdb';" 2>/dev/null | tr -d ' '; fi) || echo "not installed"
    @printf "  OCaml:        " && (if command -v incus &>/dev/null; then incus exec elcamlot-ocaml -- su - analytics -c "ocaml --version" 2>/dev/null; else docker exec elcamlot-ocaml ocaml --version 2>/dev/null; fi) || echo "container not running"
    @printf "  Dream:        " && (if command -v incus &>/dev/null; then incus exec elcamlot-ocaml -- su - analytics -c "opam show dream --field=version 2>/dev/null" 2>/dev/null; else docker exec elcamlot-ocaml sh -c "eval \$(opam env --switch=carscope) && opam show dream --field=version" 2>/dev/null; fi) || echo "container not running"
    @echo ""
    @echo "=== Latest Available ==="
    @echo "  PostgreSQL:   18.2"
    @echo "  Elixir:       1.19.5"
    @echo "  Phoenix:      1.8.3"
    @echo "  LiveView:     1.1.23"
    @echo "  Tailwind CSS: 4.1.x"
    @echo "  OCaml:        5.4.0"
    @echo "  TimescaleDB:  2.25.0"
    @echo "  pg_duckdb:    1.1.1"

# --- Alpaca Markets ---

# Seed historical bars for a symbol (usage: just alpaca-seed AAPL)
alpaca-seed symbol:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'Elcamlot.Alpaca.Seeder.seed("{{symbol}}")'

# Seed multiple symbols
alpaca-seed-batch:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'Elcamlot.Alpaca.Seeder.seed_many(~w(AAPL MSFT GOOGL AMZN TSLA SPY QQQ))'

# Show instrument stats
alpaca-stats:
    @just sql "SELECT i.symbol, count(b.*) as bars, min(b.time)::date as first, max(b.time)::date as last, round(avg(b.close_cents)/100, 2) as avg_close FROM instruments i LEFT JOIN price_bars b ON i.id = b.instrument_id GROUP BY i.id ORDER BY i.symbol;"

# Test Alpaca API health (fetch AAPL snapshot)
alpaca-health:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'IO.inspect(Elcamlot.Alpaca.fetch_snapshot("AAPL"))'

# --- Data Import/Export (pg_duckdb) ---

# Export price_bars to CSV
export-bars:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -c \
            "COPY (SELECT pb.time, i.symbol, pb.open_cents, pb.high_cents, pb.low_cents, pb.close_cents, pb.volume, pb.timeframe FROM price_bars pb JOIN instruments i ON i.id = pb.instrument_id ORDER BY pb.time) TO STDOUT WITH CSV HEADER" \
            > price_bars_export.csv; \
    else \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot -c \
            "COPY (SELECT pb.time, i.symbol, pb.open_cents, pb.high_cents, pb.low_cents, pb.close_cents, pb.volume, pb.timeframe FROM price_bars pb JOIN instruments i ON i.id = pb.instrument_id ORDER BY pb.time) TO STDOUT WITH CSV HEADER" \
            > price_bars_export.csv; \
    fi
    @echo "Exported to price_bars_export.csv ($(wc -l < price_bars_export.csv) lines)"

# Export price_snapshots to CSV
export-snapshots:
    @if command -v incus &>/dev/null; then \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -c \
            "COPY (SELECT ps.time, v.make, v.model, v.year, v.trim, ps.price_cents, ps.mileage, ps.source, ps.location, ps.url, ps.condition FROM price_snapshots ps JOIN vehicles v ON v.id = ps.vehicle_id ORDER BY ps.time) TO STDOUT WITH CSV HEADER" \
            > price_snapshots_export.csv; \
    else \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot -c \
            "COPY (SELECT ps.time, v.make, v.model, v.year, v.trim, ps.price_cents, ps.mileage, ps.source, ps.location, ps.url, ps.condition FROM price_snapshots ps JOIN vehicles v ON v.id = ps.vehicle_id ORDER BY ps.time) TO STDOUT WITH CSV HEADER" \
            > price_snapshots_export.csv; \
    fi
    @echo "Exported to price_snapshots_export.csv ($(wc -l < price_snapshots_export.csv) lines)"

# Import a CSV via pg_duckdb read_csv (usage: just import-csv bars /path/to/data.csv)
import-csv table file:
    @if command -v incus &>/dev/null; then \
        incus file push {{file}} elcamlot-pg/tmp/import.csv; \
        incus file push infra/duckdb-ingest.sql elcamlot-pg/tmp/duckdb-ingest.sql; \
        echo "Importing {{file}} into {{table}}..."; \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot \
            -v import_file="'/tmp/import.csv'" \
            -v target_table="'{{table}}'" \
            -f /tmp/duckdb-ingest.sql; \
    else \
        docker cp {{file}} elcamlot-pg:/tmp/import.csv; \
        docker cp infra/duckdb-ingest.sql elcamlot-pg:/tmp/duckdb-ingest.sql; \
        echo "Importing {{file}} into {{table}}..."; \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot \
            -v import_file="'/tmp/import.csv'" \
            -v target_table="'{{table}}'" \
            -f /tmp/duckdb-ingest.sql; \
    fi
    @echo "Import complete."

# Run cross-domain analytical queries (vehicles vs markets)
cross-analysis:
    @if command -v incus &>/dev/null; then \
        incus file push infra/cross-domain-queries.sql elcamlot-pg/tmp/cross-domain-queries.sql; \
        incus exec elcamlot-pg -- sudo -u postgres psql -d elcamlot -f /tmp/cross-domain-queries.sql; \
    else \
        docker cp infra/cross-domain-queries.sql elcamlot-pg:/tmp/cross-domain-queries.sql; \
        docker exec elcamlot-pg psql -U elcamlot -d elcamlot -f /tmp/cross-domain-queries.sql; \
    fi

# Backfill 30 days of 5-minute intraday bars for equities
backfill-intraday:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'Elcamlot.Workers.IntradayBackfillWorker.run()'

# Backfill intraday bars for a single symbol (usage: just backfill-symbol AAPL)
backfill-symbol symbol:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'Elcamlot.Workers.IntradayBackfillWorker.run(["{{symbol}}"])'

# Check market data stream status
stream-status:
    cd elcamlot && ELCAMLOT_PG_HOST=$(just pg-ip) mix run -e 'IO.inspect(Elcamlot.MarketDataStream.status())'

# --- Cleanup ---

# Remove all project containers and data
nuke:
    @echo "This will destroy ALL Elcamlot containers. Ctrl+C to cancel."
    @sleep 3
    bash infra/teardown.sh
    @echo "All containers destroyed."

# Clean Elixir build artifacts
clean:
    cd elcamlot && mix clean
    rm -rf elcamlot/_build/dev elcamlot/_build/test
