FROM alpine:3.8

RUN set -ex \
    # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      g++ \
      gcc \
      make \
      automake \
      autoconf \
      linux-headers \
      git \
 && apk add --no-cache \
      xmlto \
      asciidoc \
      libpcre32 \
      libtool \
      openssl \
      libev-dev \
      zlib-dev \
    # Build & install
 && git clone https://github.com/shadowsocks/simple-obfs.git /tmp/repo \
 && cd /tmp/repo \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && apk del .build-deps \
 && rm -rf /tmp/repo

ENTRYPOINT ["/usr/bin/obfs-server"]