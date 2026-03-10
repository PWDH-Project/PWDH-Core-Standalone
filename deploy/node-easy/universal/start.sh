#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

if ! docker image inspect pwdh-core-mainnet:latest >/dev/null 2>&1; then
  if [ -f ./pwdh-core-mainnet.tar ]; then
    docker load -i ./pwdh-core-mainnet.tar
  else
    echo "Image pwdh-core-mainnet:latest is missing and ./pwdh-core-mainnet.tar was not found."
    exit 1
  fi
fi

docker compose up -d
sleep 5

if command -v jq >/dev/null 2>&1; then
  docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getnetworkinfo | jq '{subversion,connections,connections_in,connections_out,networkactive}'
  docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getpeerinfo | jq -r '.[] | [.addr,.inbound,.subver] | @tsv' | sed -n '1,20p'
else
  docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getnetworkinfo
  docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getpeerinfo
fi
