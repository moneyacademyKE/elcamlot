defmodule Elcamlot.Containers do
  @moduledoc """
  Incus container lifecycle management — our "testcontainers" implementation.

  Provides programmatic control over Incus containers for development
  and integration testing. Spin up fresh Postgres instances, get their IPs,
  run health checks, and tear them down.
  """
  require Logger

  @default_image "images:ubuntu/noble"
  @pg_container "elcamlot-pg"
  @ocaml_container "elcamlot-ocaml"

  # --- Container Lifecycle ---

  defp backend do
    case System.find_executable("incus") do
      nil -> :docker
      _ -> :incus
    end
  end

  @doc "Launch a container. Returns {:ok, name} or {:error, reason}."
  def launch(name, opts \\ []) do
    image = Keyword.get(opts, :image, @default_image)

    case container_exists?(name) do
      true ->
        Logger.info("Container #{name} already exists, ensuring it's running")
        start(name)

      false ->
        case backend() do
          :incus ->
            case incus(["launch", image, name]) do
              {_, 0} ->
                Logger.info("Launched container #{name} from #{image}")
                wait_for_network(name)
                {:ok, name}

              {output, _} ->
                {:error, "Failed to launch #{name}: #{output}"}
            end

          :docker ->
            docker_image = if image == @default_image, do: "ubuntu:noble", else: image
            cmd_args = ["run", "-d", "--name", name, docker_image, "sleep", "infinity"]
            case System.cmd("docker", cmd_args, stderr_to_stdout: true) do
              {_, 0} ->
                Logger.info("Launched docker container #{name} from #{docker_image}")
                wait_for_network(name)
                {:ok, name}

              {output, _} ->
                {:error, "Failed to launch #{name}: #{output}"}
            end
        end
    end
  end

  @doc "Start a stopped container."
  def start(name) do
    case backend() do
      :incus ->
        case incus(["start", name]) do
          {_, 0} -> {:ok, name}
          {_, 1} -> {:ok, name}  # already running
          {output, _} -> {:error, output}
        end

      :docker ->
        case System.cmd("docker", ["start", name], stderr_to_stdout: true) do
          {_, 0} -> {:ok, name}
          {output, _} -> {:error, output}
        end
    end
  end

  @doc "Stop a running container."
  def stop(name) do
    case backend() do
      :incus ->
        case incus(["stop", name]) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end

      :docker ->
        case System.cmd("docker", ["stop", name], stderr_to_stdout: true) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end
    end
  end

  @doc "Delete a container (force stops if running)."
  def delete(name) do
    case backend() do
      :incus ->
        case incus(["delete", name, "--force"]) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end

      :docker ->
        case System.cmd("docker", ["rm", "-f", name], stderr_to_stdout: true) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end
    end
  end

  @doc "Stop and delete a container."
  def destroy(name) do
    delete(name)
  end

  # --- Container Info ---

  @doc "Get the IPv4 address of a container."
  def get_ip(name) do
    case backend() do
      :incus ->
        case incus(["list", name, "--format", "csv", "-c", "4"]) do
          {output, 0} ->
            ip =
              output
              |> String.trim()
              |> String.split(" ")
              |> List.first()

            if ip && ip != "", do: {:ok, ip}, else: {:error, :no_ip}

          {_, _} ->
            {:error, :not_found}
        end

      :docker ->
        case System.cmd("docker", ["inspect", "--format={{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}", name], stderr_to_stdout: true) do
          {output, 0} ->
            ip = String.trim(output)
            if ip && ip != "", do: {:ok, ip}, else: {:error, :no_ip}

          {_, _} ->
            {:error, :not_found}
        end
    end
  end

  @doc "Check if a container exists."
  def container_exists?(name) do
    case backend() do
      :incus ->
        case incus(["info", name]) do
          {_, 0} -> true
          _ -> false
        end

      :docker ->
        case System.cmd("docker", ["inspect", name], stderr_to_stdout: true) do
          {_, 0} -> true
          _ -> false
        end
    end
  end

  @doc "Get container state (RUNNING, STOPPED, etc)."
  def state(name) do
    case backend() do
      :incus ->
        case incus(["info", name]) do
          {output, 0} ->
            output
            |> String.split("\n")
            |> Enum.find_value(fn line ->
              case String.split(line, ":", parts: 2) do
                ["Status", value] -> String.trim(value)
                _ -> nil
              end
            end)

          _ ->
            nil
        end

      :docker ->
        case System.cmd("docker", ["inspect", "--format={{.State.Status}}", name], stderr_to_stdout: true) do
          {output, 0} ->
            case String.trim(output) do
              "running" -> "RUNNING"
              "exited" -> "STOPPED"
              other -> String.upcase(other)
            end

          _ ->
            nil
        end
    end
  end

  @doc "List all Elcamlot containers."
  def list_containers do
    case backend() do
      :incus ->
        case incus(["list", "--format", "csv", "-c", "ns4"]) do
          {output, 0} ->
            output
            |> String.trim()
            |> String.split("\n", trim: true)
            |> Enum.filter(&String.starts_with?(&1, "elcamlot-"))
            |> Enum.map(fn line ->
              [name, state, ipv4] = String.split(line, ",", parts: 3)
              %{name: name, state: state, ip: String.split(ipv4, " ") |> List.first()}
            end)

          {_, _code} ->
            []
        end

      :docker ->
        case System.cmd("docker", ["ps", "-a", "--filter", "name=elcamlot-", "--format", "{{.Names}},{{.State}},{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"], stderr_to_stdout: true) do
          {output, 0} ->
            output
            |> String.trim()
            |> String.split("\n", trim: true)
            |> Enum.map(fn line ->
              case String.split(line, ",", parts: 3) do
                [name, state, ip] ->
                  state =
                    case state do
                      "running" -> "RUNNING"
                      "exited" -> "STOPPED"
                      other -> String.upcase(other)
                    end
                  %{name: name, state: state, ip: if(ip == "", do: nil, else: ip)}

                _ ->
                  nil
              end
            end)
            |> Enum.filter(& &1)

          _ ->
            []
        end
    end
  end

  # --- Exec & Files ---

  @doc "Execute a command inside a container."
  def exec(name, command) when is_binary(command) do
    exec(name, ["--", "bash", "-c", command])
  end

  def exec(name, args) when is_list(args) do
    case backend() do
      :incus ->
        case incus(["exec", name | args]) do
          {output, 0} -> {:ok, String.trim(output)}
          {output, code} -> {:error, {code, String.trim(output)}}
        end

      :docker ->
        clean_args =
          case args do
            ["--" | rest] -> rest
            other -> other
          end

        case System.cmd("docker", ["exec", name | clean_args], stderr_to_stdout: true) do
          {output, 0} -> {:ok, String.trim(output)}
          {output, code} -> {:error, {code, String.trim(output)}}
        end
    end
  end

  @doc "Push a file into a container."
  def push_file(name, local_path, remote_path) do
    case backend() do
      :incus ->
        case incus(["file", "push", local_path, "#{name}#{remote_path}"]) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end

      :docker ->
        case System.cmd("docker", ["cp", local_path, "#{name}:#{remote_path}"], stderr_to_stdout: true) do
          {_, 0} -> :ok
          {output, _} -> {:error, output}
        end
    end
  end

  # --- Postgres-specific helpers ---

  @doc "Launch a Postgres container with TimescaleDB using our infra scripts."
  def setup_postgres(opts \\ []) do
    name = Keyword.get(opts, :name, @pg_container)

    case backend() do
      :incus ->
        script_dir = Path.join([project_root(), "infra"])
        case System.cmd("bash", [Path.join(script_dir, "setup-pg.sh")],
               stderr_to_stdout: true,
               env: [{"CONTAINER_NAME", name}]
             ) do
          {output, 0} ->
            Logger.info("Postgres container ready: #{name}")

            case get_ip(name) do
              {:ok, ip} ->
                {:ok, %{name: name, ip: ip, port: 5432, output: output}}

              {:error, reason} ->
                {:error, "Container started but failed to get IP: #{inspect(reason)}"}
            end

          {output, code} ->
            {:error, "setup-pg.sh failed (exit #{code}): #{output}"}
        end

      :docker ->
        cmd_args = [
          "run", "-d",
          "--name", name,
          "-p", "5432:5432",
          "-e", "POSTGRES_DB=elcamlot",
          "-e", "POSTGRES_USER=elcamlot",
          "-e", "POSTGRES_PASSWORD=elcamlot",
          "timescale/timescaledb:latest-pg16"
        ]

        case System.cmd("docker", cmd_args, stderr_to_stdout: true) do
          {output, code} ->
            if code == 0 or String.contains?(output, "already in use") or String.contains?(output, "Conflict") do
              System.cmd("docker", ["start", name])

              case wait_for_pg_connection(name) do
                :ok ->
                  init_db_schema_docker(name)
                  case get_ip(name) do
                    {:ok, ip} -> {:ok, %{name: name, ip: ip, port: 5432, output: "Docker container started"}}
                    {:error, reason} -> {:error, "Docker container started but failed to get IP: #{inspect(reason)}"}
                  end

                error ->
                  error
              end
            else
              {:error, "Failed to run timescale docker image: #{output}"}
            end
        end
    end
  end

  defp wait_for_pg_connection(name, retries \\ 30) do
    if retries <= 0 do
      {:error, :timeout}
    else
      case exec(name, ["pg_isready", "-U", "elcamlot"]) do
        {:ok, _} -> :ok
        _ ->
          Process.sleep(1000)
          wait_for_pg_connection(name, retries - 1)
      end
    end
  end

  defp init_db_schema_docker(name) do
    case exec(name, ["psql", "-U", "elcamlot", "-d", "elcamlot", "-c", "SELECT 1 FROM vehicles LIMIT 1;"]) do
      {:ok, _} ->
        :ok

      _ ->
        schema_path = Path.join([project_root(), "infra", "pg-init.sql"])
        push_file(name, schema_path, "/tmp/pg-init.sql")
        exec(name, ["psql", "-U", "elcamlot", "-d", "elcamlot", "-f", "/tmp/pg-init.sql"])
        :ok
    end
  end

  @doc "Check if Postgres is accepting connections."
  def pg_ready?(name \\ @pg_container) do
    case exec(name, ["pg_isready", "-U", "elcamlot"]) do
      {:ok, _} -> true
      _ -> false
    end
  end

  @doc "Wait for Postgres to be ready, with timeout."
  def wait_for_pg(name \\ @pg_container, timeout_ms \\ 30_000) do
    deadline = System.monotonic_time(:millisecond) + timeout_ms
    do_wait_pg(name, deadline)
  end

  defp do_wait_pg(name, deadline) do
    if System.monotonic_time(:millisecond) > deadline do
      {:error, :timeout}
    else
      if pg_ready?(name) do
        :ok
      else
        Process.sleep(500)
        do_wait_pg(name, deadline)
      end
    end
  end

  # --- Teardown ---

  @doc "Tear down all Elcamlot containers."
  def teardown_all do
    [@pg_container, @ocaml_container]
    |> Enum.each(fn name ->
      if container_exists?(name) do
        Logger.info("Destroying container: #{name}")
        destroy(name)
      end
    end)

    :ok
  end

  # --- Private ---

  defp incus(args) do
    System.cmd("incus", args, stderr_to_stdout: true)
  end

  defp wait_for_network(name, retries \\ 30) do
    if retries <= 0 do
      Logger.warning("Timed out waiting for network on #{name}")
      :timeout
    else
      case get_ip(name) do
        {:ok, _ip} -> :ok
        _ ->
          Process.sleep(1000)
          wait_for_network(name, retries - 1)
      end
    end
  end

  defp project_root do
    Application.app_dir(:elcamlot)
    |> Path.join("../../..")
    |> Path.expand()
  end
end
