#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="elcamlot-ocaml"
IMAGE="images:ubuntu/noble"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

echo "==> Setting up OCaml analytics container: ${CONTAINER_NAME}"

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
    echo "==> Building and launching OCaml container..."
    docker build -t elcamlot-ocaml-img "${PROJECT_ROOT}/analytics"
    docker run -d \
      --name "${CONTAINER_NAME}" \
      -p 8080:8080 \
      elcamlot-ocaml-img
  fi

  OCAML_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${CONTAINER_NAME}")
  if [ -z "$OCAML_IP" ]; then
    OCAML_IP="127.0.0.1"
  fi
  echo "==> OCaml analytics container ready! IP: ${OCAML_IP}"
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
  exit 0
fi

# Launch container
echo "==> Launching container from ${IMAGE}..."
incus launch "${IMAGE}" "${CONTAINER_NAME}"

echo "==> Waiting for container networking..."
for i in $(seq 1 30); do
  if incus exec "${CONTAINER_NAME}" -- ip -4 addr show eth0 2>/dev/null | grep -q "inet "; then
    break
  fi
  sleep 1
done

echo "==> Creating analytics user..."
incus exec "${CONTAINER_NAME}" -- bash -c '
  useradd -m -s /bin/bash analytics 2>/dev/null || true
'

echo "==> Installing OCaml toolchain..."
incus exec "${CONTAINER_NAME}" -- bash -c '
  export DEBIAN_FRONTEND=noninteractive

  apt-get update -qq
  apt-get install -y -qq build-essential curl git pkg-config \
    libev-dev libssl-dev libffi-dev zlib1g-dev \
    opam >/dev/null 2>&1
'

# Run opam as the analytics user (avoids root warnings)
incus exec "${CONTAINER_NAME}" -- su - analytics -c '
  opam init --bare --disable-sandboxing --yes

  opam switch create carscope 5.4.0 --yes

  eval $(opam env --switch=carscope)
  opam install dream yojson ppx_deriving_yojson lwt_ppx core_unix --yes
'

# Push analytics source code if it exists
if [ -d "${PROJECT_ROOT}/analytics" ]; then
  echo "==> Pushing analytics source to container..."
  incus exec "${CONTAINER_NAME}" -- mkdir -p /home/analytics/app
  incus file push -r "${PROJECT_ROOT}/analytics/" "${CONTAINER_NAME}/home/analytics/app/"
  incus exec "${CONTAINER_NAME}" -- chown -R analytics:analytics /home/analytics/app
  incus exec "${CONTAINER_NAME}" -- su - analytics -c '
    eval $(opam env --switch=carscope)
    cd ~/app && dune build 2>/dev/null || echo "Will build after source is ready"
  '
fi

OCAML_IP=$(incus list "${CONTAINER_NAME}" --format csv -c 4 | cut -d' ' -f1)
echo ""
echo "==> OCaml analytics container ready!"
echo "    Container: ${CONTAINER_NAME}"
echo "    IP:        ${OCAML_IP}"
echo "    Analytics service will listen on port 8080"
echo ""
echo "    To build & run the service:"
echo "    incus exec ${CONTAINER_NAME} -- su - analytics -c 'eval \$(opam env --switch=carscope) && cd ~/app && dune exec bin/server.exe'"
