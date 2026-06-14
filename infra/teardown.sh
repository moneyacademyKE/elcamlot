#!/usr/bin/env bash
set -euo pipefail

CONTAINERS=("elcamlot-pg" "elcamlot-ocaml")

echo "==> Tearing down Elcamlot containers..."

if ! command -v incus &> /dev/null; then
  echo "==> incus not found, falling back to docker..."
  for container in "${CONTAINERS[@]}"; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
      echo "    Stopping and deleting ${container}..."
      docker rm -f "${container}"
    else
      echo "    ${container} does not exist, skipping"
    fi
  done
  exit 0
fi

for container in "${CONTAINERS[@]}"; do
  if incus info "${container}" &>/dev/null; then
    echo "    Stopping and deleting ${container}..."
    incus stop "${container}" --force 2>/dev/null || true
    incus delete "${container}" --force
    echo "    Deleted ${container}"
  else
    echo "    ${container} does not exist, skipping"
  fi
done

echo "==> Teardown complete"
