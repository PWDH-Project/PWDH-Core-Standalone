<p align="center">
  <a href="https://github.com/PWDH-Dev/PWDH/releases">
    <img src="https://img.shields.io/github/downloads/PWDH-Dev/PWDH/total?style=for-the-badge" alt="Downloads">
  </a>
  <a href="https://pwdh.org">
    <img src="https://img.shields.io/badge/Website-Online-brightgreen?logo=google-chrome&style=for-the-badge" alt="Website">
  </a>
  <a href="https://t.me/+mc19GB_d5yo3Yjg5">
    <img src="https://img.shields.io/badge/Telegram-Join%20Chat-blue?logo=telegram&style=for-the-badge" alt="Telegram">
  </a>
  <a href="https://reddit.com/r/PWDH">
    <img src="https://img.shields.io/reddit/subreddit-subscribers/PWDH?label=Reddit&style=for-the-badge" alt="Reddit">
  </a>
  <a href="https://x.com/pwdh_community">
    <img src="https://img.shields.io/badge/X-Follow-black?logo=twitter&style=for-the-badge" alt="X">
  </a>
</p>

# PWDH Core

PWDH (Proof of Work Decentralized History) is an independent SHA-256 proof-of-work blockchain.  
PWDH Core is the reference full node implementation for validating blocks and transactions on the P2P network.

## Quick Docker Node Install

### Linux Server (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/PWDH-Project/PWDH-Core-Standalone/main/deploy/node-easy/install.sh | sudo bash
```

### Universal Linux/macOS Tar Bundle

Build the bundle:

```bash
bash deploy/node-easy/universal/package.sh
```

Run from extracted bundle:

```bash
bash install-and-run.sh
```

## Seed Hosts

- `seed01.pwdh.org`
- `seed02.pwdh.org`
- `seed03.pwdh.org`
- `seed04.pwdh.org`
- `seed05.pwdh.org`

## Documentation

- Docker build/test guide: [doc/docker-build-test.md](doc/docker-build-test.md)
- Easy node install: [deploy/node-easy/README.md](deploy/node-easy/README.md)
- Universal bundle docs: [deploy/node-easy/universal/README.md](deploy/node-easy/universal/README.md)

## License

PWDH Core is released under the MIT license. See [COPYING](COPYING).
