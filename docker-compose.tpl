version: '3'
services:
  obfs_server:
    image: jubel/obfs-server
    command: obfs-server --fast-open -s 0.0.0.0 -p "${obfs_server_listen_port}" --obfs "${obfs_server_mode}" -r "ss_server:${ss_server_listen_port}"
    restart: always
    ports:
      - "${obfs_server_listen_port}:${obfs_server_listen_port}"
    depends_on:
      - ss_server

  kcptun_server:
    image: jubel/kcptun:server
    command: -l :"${kcptun_server_listen_port}" -t "ss_server:${ss_server_listen_port}" --mode "${kcptun_server_mode}" --key "${password}"
    restart: always
    ports:
      - "${kcptun_server_listen_port}:${kcptun_server_listen_port}/udp"
    depends_on:
      - ss_server

  ss_server:
    image: shadowsocks/shadowsocks-libev:v3.2.5
    environment:
      - SERVER_PORT="${ss_server_listen_port}"
      - METHOD="${ss_server_mode}"
      - PASSWORD="${password}"
      - ARGS="--fast-open"
    restart: always
    ports:
      - "${ss_server_listen_port}:${ss_server_listen_port}"
