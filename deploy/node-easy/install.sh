#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-PWDH-Project/PWDH-Core-Standalone}"
REF="${REF:-main}"
TARGET_DIR="${TARGET_DIR:-/opt/pwdh-node}"
IMAGE="${PWDH_IMAGE:-ghcr.io/pwdh-project/pwdh-core-daemon:1.0.0}"

if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ca-certificates curl docker.io docker-compose-v2 ufw
  systemctl enable --now docker
fi

mkdir -p "${TARGET_DIR}"
curl -fsSL "https://raw.githubusercontent.com/${REPO}/${REF}/deploy/node-easy/docker-compose.yml" -o "${TARGET_DIR}/docker-compose.yml"
curl -fsSL "https://raw.githubusercontent.com/${REPO}/${REF}/deploy/node-easy/pwdh.conf" -o "${TARGET_DIR}/pwdh.conf"

cd "${TARGET_DIR}"
PWDH_IMAGE="${IMAGE}" docker compose up -d

if command -v ufw >/dev/null 2>&1; then
  ufw allow 22/tcp >/dev/null 2>&1 || true
  ufw allow 37934/tcp >/dev/null 2>&1 || true
fi

docker compose ps
