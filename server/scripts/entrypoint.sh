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
PostUp   = iptables -A FORWARD -i wg0 -o nsm0 -j ACCEPT
PostUp   = iptables -A FORWARD -i nsm0 -o wg0 -j ACCEPT
PostUp   = iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostUp   = iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostUp   = iptables -t nat -A POSTROUTING -o nsm0 -j MASQUERADE

PostDown = iptables -D FORWARD -i wg0 -o nsm0 -j ACCEPT
PostDown = iptables -D FORWARD -i nsm0 -o wg0 -j ACCEPT
PostDown = iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o nsm0 -j MASQUERADE

[Peer]
PublicKey = ${PEER_PUBLIC_KEY}
AllowedIPs = ${ALLOWED_IPS}
PersistentKeepalive = ${PERSISTENT_KEEPALIVE}
EOF

wg-quick up "${WG_CONF_FILE}"

# keep alive
exec tail -f /dev/null
