# IMAGE: jubel/ss:server
FROM ubuntu:16.04
MAINTAINER Jubel Ansiple <jubel.ansiple@gmail.com>

RUN apt-get update && \
    apt-get install -y python-pip && \
    pip install shadowsocks

ENTRYPOINT ["/usr/local/bin/ssserver"]
