#!/bin/bash

PWD=$(pwd)
DIR=$(basename $PWD)

start() {
  docker-compose up -d
  docker run \
    --rm \
    -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(pwd):/root" \
    --network "${DIR}_default" \
    --name tmuxinator \
    tmuxinator:latest \
    tmuxinator start -p /root/tmuxinator-replication.yml
  docker-compose down
}
start
