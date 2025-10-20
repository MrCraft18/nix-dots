#!/usr/bin/env bash
set -euxo pipefail

sync_target=$1
position=$2

: "${HOST:=${HOSTNAME:-$(hostname -s)}}"

# check if sync_target is added as a lan-mouse client
    # if it isnt then add it
if ! lan-mouse cli list 2>/dev/null | sed -n 's/^id [0-9]\+: \([[:alnum:]_.-]\+\):.*/\1/p' | grep -qx $sync_target; then
    lan-mouse cli add-client --hostname $sync_target --port 4242
fi

# grab the id of the sync_target client
sync_client_id="$(lan-mouse cli list 2>/dev/null | awk -v H="$sync_target" '
    /^id [0-9]+:/ {
        id=$2; sub(/:/,"",id)
        host=$3; sub(/:.*/,"",host)
        if (host==H) { print id; exit }
    }
')"

# set lan-mouse client position
lan-mouse cli set-position $sync_client_id $position

# activate client
lan-mouse cli activate $sync_client_id

# authorize fingerprint on sync_target
ssh $sync_target "lan-mouse cli authorize-key $HOST $(nix run nixpkgs\#openssl -- x509 -in "$HOME/.config/lan-mouse/lan-mouse.pem" -noout -fingerprint -sha256 | awk -F= '{print tolower($2)}')"

# check if pactl tcp module has been initialized
    # if it isnt initialize it
if ! pactl list short modules | grep module-native-protocol-tcp; then
    pactl load-module module-native-protocol-tcp auth-anonymous=1 port=4243 auth-ip-acl=100.64.0.0/10
fi

# check if tunnel modules for source and sink on sync_target are loaded
    # load them if not
if ! ssh $sync_target "pactl list short sinks | awk -v n=tunnel-sink.$HOST:4243 '$2==n{found=1} END{exit !found}'"; then
    ssh $sync_target pactl load-module module-tunnel-sink server="$HOST:4243" latency_msec=500
fi
if ! ssh $sync_target "pactl list short sources | awk -v n=tunnel-source.$HOST:4243 '$2==n{found=1} END{exit !found}'"; then
    ssh $sync_target pactl load-module module-tunnel-source server="$HOST:4243"
fi

# set default sink and source to tcp tunnels on sync_target
ssh "$sync_target" "pactl set-default-sink tunnel-sink.$HOST:4243" 
ssh "$sync_target" "pactl set-default-source tunnel-source.$HOST:4243" 

echo "Done"
