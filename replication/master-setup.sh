#!/bin/bash
# replication/master-setup.sh

set -e
set -f #noglob

. ./shared.sh

shared::init "mysql_master"
shared::wait_on_mysql
shared::query "CREATE USER 'repl_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password'"
shared::query "GRANT REPLICATION SLAVE ON *.* TO repl_user@'%'"
shared::query "CREATE DATABASE repl_demo"
shared::query "CREATE TABLE repl_demo.table1 (id int not null primary key)"

count=1
while true; do
  shared::query "INSERT INTO repl_demo.table1 VALUES ($count)"
  count=$((count + 1))
  sleep 1
done
