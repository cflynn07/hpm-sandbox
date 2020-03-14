#!/bin/bash

_container=""

# waits for mysql _container to exist
check_container() {
  docker inspect "$1" &>/dev/null
}

# echos red text
shared::attn_output() {
  echo -e "\e[1;31m demo:> $1\e[0m"
}

# initialize database client
# $1 host
shared::init() {
  _container=$1
  echo "[client]" >> /etc/mysql/my.cnf
  echo "password=password" >> /etc/mysql/my.cnf
  echo "user=root" >> /etc/mysql/my.cnf
  echo "host=$_container" >> /etc/mysql/my.cnf
}

# runs a mysql query
# $1 query
shared::query () {
  shared::attn_output "QUERY: \"$1\""
  echo "$1" | mysql
}

# waits for mysql container to exist and be ready
shared::wait_on_mysql() {
  shared::attn_output "waiting for $_container to start..."
  while ! check_container "$_container"; do
    echo "$_container not found, sleep 1..."
    sleep 1
  done

  CID=$(docker inspect "$_container" -f "{{ .Id }}")
  shared::attn_output "found $_container , ID: $CID"

  shared::attn_output "waiting for $_container to be ready..."
  while ! shared::query "show databases;" &>/dev/null; do
    sleep 1
    shared::attn_output "$_container not yet ready, sleep 1..."
  done
  shared::attn_output "$_container ready"
}
