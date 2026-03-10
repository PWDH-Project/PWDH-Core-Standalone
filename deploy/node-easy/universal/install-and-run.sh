#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

wait_for_docker() {
  local i=0
  until docker info >/dev/null 2>&1; do
    i=$((i+1))
    if [ "$i" -ge 60 ]; then
      echo "Docker daemon is not available yet."
      exit 1
    fi
    sleep 2
  done
}

ensure_docker_linux() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    return
  fi
  if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y ca-certificates curl docker.io docker-compose-v2
    systemctl enable --now docker
    return
  fi
  echo "Docker could not be installed automatically. Currently only apt-based Linux distributions are supported."
  exit 1
}

ensure_docker_macos() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    wait_for_docker
    return
  fi
  if command -v brew >/dev/null 2>&1; then
    brew install --cask docker
    open -a Docker
    wait_for_docker
    return
  fi
  echo "Docker Desktop is missing. Install Docker Desktop and run the script again."
  exit 1
}

if [ "$OS" = "Linux" ]; then
  if [ "$(id -u)" -eq 0 ]; then
    ensure_docker_linux
  else
    sudo bash "$0"
    exit 0
  fi
elif [ "$OS" = "Darwin" ]; then
  ensure_docker_macos
else
  echo "Unsupported operating system: $OS"
  exit 1
fi

cd "${SCRIPT_DIR}"
bash ./start.sh
