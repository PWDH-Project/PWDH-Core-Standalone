#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
OUT_DIR="${ROOT_DIR}/release-artifacts/docker-node-universal"
BUNDLE_DIR="${OUT_DIR}/pwdh-docker-node"

rm -rf "${OUT_DIR}"
mkdir -p "${BUNDLE_DIR}"

docker save -o "${BUNDLE_DIR}/pwdh-core-mainnet.tar" pwdh-core-mainnet:latest
cp "${SCRIPT_DIR}/docker-compose.yml" "${BUNDLE_DIR}/docker-compose.yml"
cp "${SCRIPT_DIR}/pwdh.conf" "${BUNDLE_DIR}/pwdh.conf"
cp "${SCRIPT_DIR}/start.sh" "${BUNDLE_DIR}/start.sh"
cp "${SCRIPT_DIR}/stop.sh" "${BUNDLE_DIR}/stop.sh"
cp "${SCRIPT_DIR}/install-and-run.sh" "${BUNDLE_DIR}/install-and-run.sh"
chmod +x "${BUNDLE_DIR}/start.sh" "${BUNDLE_DIR}/stop.sh" "${BUNDLE_DIR}/install-and-run.sh"

cat > "${BUNDLE_DIR}/README.txt" <<'EOF'
Linux/macOS One-Command:
bash ./install-and-run.sh

Manuell:
./start.sh
./stop.sh
EOF

tar -czf "${OUT_DIR}/pwdh-docker-node-universal.tar.gz" -C "${OUT_DIR}" "pwdh-docker-node"
echo "${OUT_DIR}/pwdh-docker-node-universal.tar.gz"
