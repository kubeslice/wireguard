#!/usr/bin/env bash
set -euo pipefail

WG_CONF_DIR=/etc/wireguard
WG_CONF_FILE=${WG_CONF_DIR}/wg0.conf
PERSISTENT_KEEPALIVE=25
mkdir -p "${WG_CONF_DIR}"

# Read keys from mounted secret files
PRIVATE_KEY=$(cat /etc/wireguard/privatekey)
PEER_PUBLIC_KEY=$(cat /etc/wireguard/publickey)

# Build the client config
cat > "${WG_CONF_FILE}" <<EOF
[Interface]
Address = ${ADDRESS}
ListenPort = ${PORT}
PrivateKey = ${PRIVATE_KEY}
MTU = 1300
PostUp   = sysctl -w net.ipv4.ip_forward=1

[Peer]
PublicKey = ${PEER_PUBLIC_KEY}
AllowedIPs = ${ALLOWED_IPS}
PersistentKeepalive = ${PERSISTENT_KEEPALIVE}
EOF

wg-quick up "${WG_CONF_FILE}"

# keep alive
exec tail -f /dev/null
