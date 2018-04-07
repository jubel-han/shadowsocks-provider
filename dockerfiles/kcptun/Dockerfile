# IMAGE: jubel/kcptun:server
FROM ubuntu:16.04
MAINTAINER Jubel Ansiple <jubel.ansiple@gmail.com>

ENV VERSION "20180316"
ENV DOWNLOAD_URL "https://github.com/xtaci/kcptun/releases/download/v${VERSION}/kcptun-linux-amd64-${VERSION}.tar.gz"

RUN apt-get update && \
    apt-get install -y wget && \
    wget -O kcptun.tar.gz ${DOWNLOAD_URL} && \
    tar -xvf kcptun.tar.gz && \
    rm -f client_linux_amd64 && \
    mv server_linux_amd64 kcptun_server

ENTRYPOINT ["/kcptun_server"]
