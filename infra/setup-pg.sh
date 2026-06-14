#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="elcamlot-pg"
IMAGE="images:ubuntu/noble"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Setting up Postgres container: ${CONTAINER_NAME}"

# Check if container already exists
if ! command -v incus &> /dev/null; then
  echo "==> incus not found, falling back to docker..."
  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} already exists."
    state=$(docker inspect --format='{{.State.Status}}' "${CONTAINER_NAME}")
    if [ "$state" != "running" ]; then
      echo "Starting existing container..."
      docker start "${CONTAINER_NAME}"
    fi
  else
    echo "==> Launching container from timescale/timescaledb:latest-pg16..."
    docker run -d \
      --name "${CONTAINER_NAME}" \
      -p 5432:5432 \
      -e POSTGRES_DB=elcamlot \
      -e POSTGRES_USER=elcamlot \
      -e POSTGRES_PASSWORD="${PG_PASSWORD:-elcamlot}" \
      timescale/timescaledb:latest-pg16
  fi

  echo "==> Waiting for Postgres to start..."
  for i in $(seq 1 30); do
    if docker exec "${CONTAINER_NAME}" pg_isready -U elcamlot &>/dev/null; then
      break
    fi
    sleep 1
  done

  # Check if schema is loaded
  if ! docker exec "${CONTAINER_NAME}" psql -U elcamlot -d elcamlot -c "SELECT 1 FROM vehicles LIMIT 1;" &>/dev/null; then
    echo "==> Loading schema..."
    docker cp "${SCRIPT_DIR}/pg-init.sql" "${CONTAINER_NAME}:/tmp/pg-init.sql"
    docker exec "${CONTAINER_NAME}" psql -U elcamlot -d elcamlot -f /tmp/pg-init.sql
  fi

  PG_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${CONTAINER_NAME}")
  if [ -z "$PG_IP" ]; then
    PG_IP="127.0.0.1"
  fi
  echo "==> Postgres container ready! IP: ${PG_IP}"
  exit 0
fi

if incus info "${CONTAINER_NAME}" &>/dev/null; then
  echo "Container ${CONTAINER_NAME} already exists."
  state=$(incus info "${CONTAINER_NAME}" | grep "Status:" | awk '{print $2}')
  if [ "$state" != "RUNNING" ]; then
    echo "Starting existing container..."
    incus start "${CONTAINER_NAME}"
  fi
  echo "==> Container is running"
  incus exec "${CONTAINER_NAME}" -- pg_isready -U elcamlot && echo "==> Postgres is ready" && exit 0
  echo "Postgres not ready yet, waiting..."
fi

# Launch container
if ! incus info "${CONTAINER_NAME}" &>/dev/null; then
  echo "==> Launching container from ${IMAGE}..."
  incus launch "${IMAGE}" "${CONTAINER_NAME}"

  echo "==> Waiting for container networking..."
  for i in $(seq 1 30); do
    if incus exec "${CONTAINER_NAME}" -- ip -4 addr show eth0 2>/dev/null | grep -q "inet "; then
      break
    fi
    sleep 1
  done
fi

echo "==> Installing Postgres 16 + TimescaleDB..."
incus exec "${CONTAINER_NAME}" -- bash -c '
  export DEBIAN_FRONTEND=noninteractive

  # Add PostgreSQL APT repo
  apt-get update -qq
  apt-get install -y -qq curl gnupg lsb-release >/dev/null 2>&1

  # PostgreSQL official repo
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/pgdg.gpg
  echo "deb [signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list

  # TimescaleDB repo
  curl -fsSL https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor -o /usr/share/keyrings/timescaledb.gpg
  echo "deb [signed-by=/usr/share/keyrings/timescaledb.gpg] https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/timescaledb.list

  # DuckDB repo for pg_duckdb
  curl -fsSL https://install.duckdb.org/pgdg/gpg.key | gpg --dearmor -o /usr/share/keyrings/duckdb.gpg
  echo "deb [signed-by=/usr/share/keyrings/duckdb.gpg] https://install.duckdb.org/pgdg $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/duckdb.list

  apt-get update -qq
  apt-get install -y -qq postgresql-18 timescaledb-2-postgresql-18 >/dev/null 2>&1

  # pg_duckdb (optional — analytics queries fall back to regular Postgres)
  apt-get install -y -qq postgresql-18-pg-duckdb >/dev/null 2>&1 || echo "WARN: pg_duckdb not available, skipping"

  # Configure TimescaleDB
  timescaledb-tune --quiet --yes

  # Configure Postgres to accept connections from host
  PG_HBA="/etc/postgresql/18/main/pg_hba.conf"
  PG_CONF="/etc/postgresql/18/main/postgresql.conf"

  # Listen on all interfaces
  sed -i "s/#listen_addresses = .*/listen_addresses = '\''*'\''/" "$PG_CONF"

  # Allow connections from Incus bridge subnet
  echo "host all all 0.0.0.0/0 md5" >> "$PG_HBA"

  # Restart Postgres
  systemctl restart postgresql
  systemctl enable postgresql

  # Create elcamlot database and user
  sudo -u postgres psql -c "CREATE USER elcamlot WITH PASSWORD '\''${PG_PASSWORD:-elcamlot}'\'' CREATEDB;"
  sudo -u postgres psql -c "CREATE DATABASE elcamlot OWNER elcamlot;"
  sudo -u postgres psql -d elcamlot -c "GRANT ALL PRIVILEGES ON DATABASE elcamlot TO elcamlot;"
'

echo "==> Loading schema..."
incus file push "${SCRIPT_DIR}/pg-init.sql" "${CONTAINER_NAME}/tmp/pg-init.sql"
incus exec "${CONTAINER_NAME}" -- sudo -u postgres psql -d elcamlot -f /tmp/pg-init.sql

echo "==> Waiting for Postgres to be ready..."
for i in $(seq 1 15); do
  if incus exec "${CONTAINER_NAME}" -- pg_isready -U elcamlot 2>/dev/null; then
    break
  fi
  sleep 1
done

# Print connection info
PG_IP=$(incus list "${CONTAINER_NAME}" --format csv -c 4 | cut -d' ' -f1)
echo ""
echo "==> Postgres container ready!"
echo "    Container: ${CONTAINER_NAME}"
echo "    IP:        ${PG_IP}"
echo "    Port:      5432"
echo "    Database:  elcamlot"
echo "    User:      elcamlot"
echo "    Password:  \${PG_PASSWORD:-elcamlot}  (override with PG_PASSWORD env var)"
echo ""
echo "    Connection string:"
echo "    postgres://elcamlot:\${PG_PASSWORD:-elcamlot}@${PG_IP}:5432/elcamlot"
