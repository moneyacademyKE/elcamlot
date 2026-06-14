# Architectural Patterns: Elcamlot

## 1. Dynamic Backend Strategy Pattern
When a system dependency (e.g. virtualization orchestrator) is environment-dependent, isolate it behind a unified contract:
* **Interface**: Standard container command signatures (`launch/2`, `start/1`, `get_ip/1`, `exec/2`).
* **Resolution**: Runtime detection (`backend/0`) dispatching commands to either `incus` or `docker` binaries.
* **Benefits**: High portability, zero configuration required by the developer, seamless VM/macOS compatibility.

## 2. SQL to Map-Atom Adapter Pattern
Ecto queries run through `Ecto.Adapters.SQL.query/4` return raw relational data containing string column headers. Adapt them at the context boundary:
```elixir
Enum.zip(columns, row)
|> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
|> Map.new()
```
* **Benefits**: Restores dot-notation struct-style accessibility while keeping DB headers decoupled from client schemas.

## 3. Asynchronous LiveView Task Updates
Instead of blocking Phoenix LiveView `mount/3` or `handle_info/2` on slow third-party API payloads:
* **Trigger**: Check `connected?(socket)` and fire parallel `Task.async/1` executions mapping results to identifier keys (e.g. `{:depreciation, value}`).
* **Resolution**: Handle messages in `handle_info/2` matching on the task's return value.
* **Benefits**: Decouples network/external computational latency from page rendering, improving responsiveness and overall page weight loading speed.

## 4. Job Delegation Pattern (Rich Hickey Simplicity)
Instead of processing a massive batch of work in a single synchronous worker job:
* **Pattern**: Create an Enqueuer Job that purely queries for the list of targets and enqueues individual Worker Jobs for each target using Oban's `insert_all`.
* **Execution**: The discrete Worker Jobs (`ScoreVehicleWorker`) perform the fetching, pure computation, and persistence for exactly one entity.
* **Benefits**: Decouples search from execution. Prevents a single external API timeout from failing the entire batch. Maximizes throughput via isolated, independent job retry states.
