#!/bin/bash
set -euo pipefail

export PATH=${PATH}:/usr/bin

# setup proxy
LOCALPORT=${LOCALPORT:-"82"}
exec su-exec root tcp-proxy -l="0.0.0.0:${LOCALPORT}" -r="${REMOTEADDR}" &

PRESCRIPT=${PRESCRIPT:-"NOSUCHFILE"}
if [ -f ${PRESCRIPT} ]; then
	exec su-exec root bash ${PRESCRIPT} &
fi

# setup vpn
if [ $# -gt 0 ] && [ "$1" = 'openfortivpn' ]; then
#    exec su-exec root "$@"
#   above will cause ipc not working (i.e. sem-post not fire or sem-wait not received)
    exec "$@"
fi

exec "$@"

