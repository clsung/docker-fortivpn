FROM golang:1.9-alpine as builder

ENV OPENFORTIVPN_VERSION=v1.6.0

RUN apk update && apk upgrade && \
	apk add --no-cache bash \
	bind-tools \
	openssl-dev \
	expect \
	git \
	ppp 

# Install openfortivpn
RUN apk --update upgrade \
    && apk add ca-certificates wget \
    && update-ca-certificates \
    && apk add --no-cache --virtual .build-deps \
        automake \
        autoconf \
        g++ \
        gcc \
        make \
    && mkdir -p /usr/src/openfortivpn \
    && cd /usr/src/openfortivpn \
    && wget https://github.com/adrienverge/openfortivpn/archive/${OPENFORTIVPN_VERSION}.tar.gz \
    && tar xvf $OPENFORTIVPN_VERSION.tar.gz --strip-components 1 \
    && cd /usr/src/openfortivpn \
    && aclocal && autoconf && automake --add-missing \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make \
    && make install \
    && apk del .build-deps

RUN go get github.com/jpillora/go-tcp-proxy/cmd/tcp-proxy
RUN go get github.com/coreos/etcd/cmd/etcdctl  # https://github.com/coreos/etcd/issues/7487


FROM alpine:3.6

RUN apk --no-cache add ca-certificates openssl ppp curl su-exec bash && rm -rf /var/cache/apk/*;

WORKDIR /
COPY --from=builder /usr/bin/openfortivpn /usr/bin/openfortivpn
COPY --from=builder /go/bin/tcp-proxy /usr/bin/tcp-proxy
COPY --from=builder /go/bin/etcdctl /usr/bin/etcdctl
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["openfortivpn"]
