#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

# Load .env file
if [ -f "${PROJECT_ROOT}/.env" ]; then
  set -a
  source "${PROJECT_ROOT}/.env"
  set +a
  echo "==> Loaded .env"
fi

echo "==> Starting Elcamlot dev environment..."

# Ensure containers are up
echo "==> Setting up Postgres..."
bash "${PROJECT_ROOT}/infra/setup-pg.sh"

echo ""
echo "==> Setting up OCaml analytics..."
bash "${PROJECT_ROOT}/infra/setup-ocaml.sh"

# Get container IPs
if command -v incus &> /dev/null; then
  PG_IP=$(incus list elcamlot-pg --format csv -c 4 | cut -d' ' -f1)
  OCAML_IP=$(incus list elcamlot-ocaml --format csv -c 4 | cut -d' ' -f1)
else
  PG_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elcamlot-pg)
  OCAML_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elcamlot-ocaml)
  if [ -z "${PG_IP}" ]; then PG_IP="127.0.0.1"; fi
  if [ -z "${OCAML_IP}" ]; then OCAML_IP="127.0.0.1"; fi
fi

echo ""
echo "==> Dev environment ready!"
echo "    Postgres:  postgres://elcamlot:\${PG_PASSWORD:-elcamlot}@${PG_IP}:5432/elcamlot"
echo "    OCaml API: http://${OCAML_IP}:8080"
echo ""
echo "==> Starting Phoenix..."
cd "${PROJECT_ROOT}/elcamlot"

export ELCAMLOT_PG_HOST="${PG_IP}"
export DATABASE_URL="postgres://elcamlot:${PG_PASSWORD:-elcamlot}@${PG_IP}:5432/elcamlot"
export ANALYTICS_URL="http://${OCAML_IP}:8080"

mix phx.server
