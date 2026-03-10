# Docker Build and Test for PWDH Core

## Build + Validation Test

```bash
docker compose build pwdh-build-test
```

The `test` target builds `pwdhd` with SHA-256 PoW rules and runs the `validation_tests` unit test.

## Build Runtime Image

```bash
docker compose build pwdh-runtime
```

## Run Runtime in Regtest

```bash
docker compose run --rm pwdh-runtime
```

## Run Persistent Testnet Daemon

```bash
docker compose up -d pwdh-testnet
docker compose logs -f pwdh-testnet
docker compose down
```

## Run Persistent Mainnet Daemon

```bash
docker compose up -d pwdh-mainnet
docker compose logs -f pwdh-mainnet
```

## Linux Daemon Without Local Build

For users without a local build chain, a release package provides prebuilt Linux binaries (`pwdhd`, `pwdh-cli`, `pwdh-tx`, `pwdh-wallet`).

Create and push a release tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow `.github/workflows/release-linux-daemon.yml` publishes `PWDH-Core-<version>-linux-x86_64.tar.gz`.

Install a node from the release package:

```bash
sudo REPO=PWDH-Project/PWDH-Core-Standalone VERSION=1.0.0 bash deploy/linux/install-node.sh
```

## Easy Docker Node Install

The `deploy/node-easy` directory contains a lightweight mainnet daemon setup based on a prebuilt image.

```bash
curl -fsSL https://raw.githubusercontent.com/PWDH-Project/PWDH-Core-Standalone/main/deploy/node-easy/install.sh | sudo bash
```

## Universal Linux/macOS Docker Tar

For a portable one-command install, use `deploy/node-easy/universal`.

Build the bundle:

```bash
bash deploy/node-easy/universal/package.sh
```

Run the bundle on Linux or macOS:

```bash
bash install-and-run.sh
```
