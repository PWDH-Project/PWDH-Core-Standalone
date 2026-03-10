#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
OUT_DIR="${ROOT_DIR}/release-artifacts/macos-node-bundle"
BUNDLE_DIR="${OUT_DIR}/pwdh-macos-node"

rm -rf "${OUT_DIR}"
mkdir -p "${BUNDLE_DIR}"

docker save -o "${BUNDLE_DIR}/pwdh-core-mainnet.tar" pwdh-core-mainnet:latest
cp "${SCRIPT_DIR}/docker-compose.yml" "${BUNDLE_DIR}/docker-compose.yml"
cp "${SCRIPT_DIR}/pwdh.conf" "${BUNDLE_DIR}/pwdh.conf"
cp "${SCRIPT_DIR}/start.sh" "${BUNDLE_DIR}/start.sh"
cp "${SCRIPT_DIR}/stop.sh" "${BUNDLE_DIR}/stop.sh"
chmod +x "${BUNDLE_DIR}/start.sh" "${BUNDLE_DIR}/stop.sh"

cat > "${BUNDLE_DIR}/README.txt" <<'EOF'
1) cd pwdh-macos-node
2) chmod +x start.sh stop.sh
3) ./start.sh
4) ./stop.sh
EOF

tar -czf "${OUT_DIR}/pwdh-macos-node-bundle.tar.gz" -C "${OUT_DIR}" "pwdh-macos-node"
echo "${OUT_DIR}/pwdh-macos-node-bundle.tar.gz"
