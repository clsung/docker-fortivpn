#!/bin/bash
set -euo pipefail

export PATH=${PATH}:/usr/bin

# setup proxy
LOCALPORT=${LOCALPORT:-"82"}
exec su-exec root tcp-proxy -l="0.0.0.0:${LOCALPORT}" -r="${REMOTEADDR}" &

# setup vpn
if [ $# -gt 0 ] && [ "$1" = 'openfortivpn' ]; then
    exec su-exec root "$@"
fi

exec "$@"

