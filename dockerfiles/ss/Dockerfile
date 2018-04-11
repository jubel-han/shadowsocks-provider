# IMAGE: jubel/ss:server
FROM ubuntu:16.04
MAINTAINER Jubel Ansiple <jubel.ansiple@gmail.com>

RUN apt-get update && \
    apt-get install -y python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install shadowsocks

ENTRYPOINT ["/usr/local/bin/ssserver"]
