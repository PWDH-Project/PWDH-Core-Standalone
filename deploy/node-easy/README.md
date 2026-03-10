# PWDH Node Easy Install

## One-Command Installation

```bash
curl -fsSL https://raw.githubusercontent.com/PWDH-Project/PWDH-Core-Standalone/main/deploy/node-easy/install.sh | sudo bash
```

## Installation with Explicit Versioned Image

```bash
curl -fsSL https://raw.githubusercontent.com/PWDH-Project/PWDH-Core-Standalone/main/deploy/node-easy/install.sh | sudo PWDH_IMAGE=ghcr.io/pwdh-project/pwdh-core-daemon:1.0.0 bash
```

## Service Management

```bash
cd /opt/pwdh-node
docker compose ps
docker compose logs -f pwdh-mainnet
docker compose restart pwdh-mainnet
```

## RPC Checks

```bash
cd /opt/pwdh-node
docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getblockchaininfo
docker compose exec -T pwdh-mainnet pwdh-cli -datadir=/var/lib/pwdh getnetworkinfo
```
