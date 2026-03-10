#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-PWDH-Project/PWDH-Core-Standalone}"
VERSION="${VERSION:-1.0.0}"
ARCHIVE="PWDH-Core-${VERSION}-linux-x86_64.tar.gz"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ARCHIVE}"
WORKDIR="$(mktemp -d)"

trap 'rm -rf "$WORKDIR"' EXIT

curl -fL "$URL" -o "${WORKDIR}/${ARCHIVE}"
tar -xzf "${WORKDIR}/${ARCHIVE}" -C "${WORKDIR}"

install -m 0755 "${WORKDIR}/PWDH-Core-${VERSION}-linux-x86_64/bin/pwdhd" /usr/local/bin/pwdhd
install -m 0755 "${WORKDIR}/PWDH-Core-${VERSION}-linux-x86_64/bin/pwdh-cli" /usr/local/bin/pwdh-cli
install -m 0755 "${WORKDIR}/PWDH-Core-${VERSION}-linux-x86_64/bin/pwdh-tx" /usr/local/bin/pwdh-tx
install -m 0755 "${WORKDIR}/PWDH-Core-${VERSION}-linux-x86_64/bin/pwdh-wallet" /usr/local/bin/pwdh-wallet

mkdir -p /etc/pwdh /var/lib/pwdh
if [ ! -f /etc/pwdh/pwdh.conf ]; then
  cp "${WORKDIR}/PWDH-Core-${VERSION}-linux-x86_64/config/pwdh.conf" /etc/pwdh/pwdh.conf
fi

cat >/etc/systemd/system/pwdhd.service <<'UNIT'
[Unit]
Description=PWDH daemon
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/pwdhd -server=1 -listen=1 -txindex=1 -datadir=/var/lib/pwdh -conf=/etc/pwdh/pwdh.conf
Restart=on-failure
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now pwdhd
sleep 2
/usr/local/bin/pwdh-cli -datadir=/var/lib/pwdh getblockchaininfo || true
