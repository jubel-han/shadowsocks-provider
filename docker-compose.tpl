version: '3'
services:
  kcptun_server:
    image: jubel/kcptun:server
    command: -l :"${kcptun_server_listen_port}" -t "ss_server:${ss_server_listen_port}" --mode "${kcptun_server_mode}" --key "${password}"
    restart: always
    ports:
      - "${kcptun_server_listen_port}:${kcptun_server_listen_port}/udp"
    depends_on:
      - ss_server

  ss_server:
    image: jubel/ss:server
    command: --fast-open -p "${ss_server_listen_port}" -k "${password}" -m "${ss_server_mode}" --workers "${ss_server_workers_count}"
    restart: always
    ports:
      - "${ss_server_listen_port}:${ss_server_listen_port}"
