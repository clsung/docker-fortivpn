# docker-fortivpn
SSL-VPN docker 

## Usage

`% docker run -ti -e REMOTEADDR="1.1.1.2:8765" -e LOCALPORT="88" -p 9453:88 -v /path/to/openfortivpn/config:/etc/openfortivpn/config --rm --device=/dev/ppp --cap-add=NET_ADMIN clsung/openfortivpn:v0.1`

## Build
% ./build.sh

### Prerequirement
Docker Engine CE >= 17.05

## Reference
- [Docker Multistage Build](https://docs.docker.com/engine/userguide/eng-image/multistage-build/)
