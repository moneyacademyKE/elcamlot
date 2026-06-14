# Learnings: Elcamlot macOS Port and Container Abstraction

## 1. Multi-Platform Container Abstraction (Incus & Docker)
* **Problem**: The codebase relied heavily on Linux-specific Incus container virtualization (`System.cmd("incus", ...)`), which is unavailable natively on macOS.
* **Solution**: Refactored `Elcamlot.Containers` to dynamically query host capabilities (`System.find_executable("incus")`). If unavailable, it seamlessly falls back to Docker commands using OrbStack, ensuring local container orchestration works out of the box on macOS.
* **Key Lesson**: Keep the container lifecycle API clean and data-driven (`launch`, `start`, `stop`, `delete`, `exec`). The caller shouldn't care *how* the isolation is achieved (LXD/Incus vs. OCI/Docker), keeping the boundary unentangled (a key Rich Hickey principle).

## 2. Shell vs. API Integrations
* **Problem**: Scripted shell installations (`setup-pg.sh`, `setup-ocaml.sh`) were written for Ubuntu package management inside containers.
* **Solution**: Provided native OCI Docker container setups (e.g. using `timescale/timescaledb` and building an OCaml Dream server image using a standard multi-stage `Dockerfile`).
* **Key Lesson**: Declarative container definitions (`docker-compose.yml`, `Dockerfile`) are more portable and reliable than imperative provisioning bash scripts.

## 3. SQL Query Map Access
* **Problem**: Ecto SQL adapter results return column keys as strings (e.g., `%{"count" => 5}`), whereas test assertions and template code expected atom keys (e.g., `stats.count`). This caused `KeyError` crashes.
* **Solution**: Standardized `Markets.price_stats/2` and `Vehicles.price_stats/1` to translate database column headers to atoms before returning results.
* **Key Lesson**: Standardize representation boundaries at context entry points to match application expectations.

## 4. Asynchronous Execution in LiveViews
* **Problem**: When mounting `DashboardLive`, five sequential HTTP calls to the external OCaml service were executed synchronously. This blocked rendering, causing slow visual load times and potential process starvation if the analytics service lagged.
* **Solution**: Offloaded the calls into parallel asynchronous execution tasks (`Task.async/1`) inside `start_async_analytics/3` when the socket is connected.
* **Key Lesson**: Use task messaging (`handle_info/2` matching on the task result tuple) to update LiveView socket assigns as each calculation completes. This decouples user-facing rendering from microservice latency, ensuring instantaneous initial loads and reactive updates.

## 5. Rich Hickey Simplicity Audit & Refactoring
* **Problem**: System processes suffered from Temporal Coupling and Entanglement. `DealScoreWorker` fetched all data and sequentially called external services in a single massive blocking job. `MarketDataStream` tied network ingestion directly to database writes in the same GenServer process.
* **Solution**: 
  - Refactored `DealScoreWorker` into a simple enqueuer that dispatches individual `ScoreVehicleWorker` jobs, separating the "what needs work" from the "doing the work".
  - Refactored `MarketDataStream` to use `Task.Supervisor.async_nolink` to offload database writes, protecting the WebSocket buffer from DB-induced latency.
* **Key Lesson**: Embrace Rich Hickey's *Simple Made Easy* by separating concerns across time and space. Do not braid network fetching, pure calculation, and database persistence. Unentangling these processes yields highly resilient, scalable background jobs and streaming ingestion.
