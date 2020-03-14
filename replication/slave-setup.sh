#!/bin/bash
# replication/slave-setup.sh

# set -e
set -f #noglob

. ./shared.sh

shared::init "mysql_slave"
shared::wait_on_mysql
shared::query "CHANGE MASTER TO MASTER_HOST='mysql_master',
  MASTER_USER='repl_user',
  MASTER_PASSWORD='password',
  MASTER_LOG_FILE='master-bin.log',
  MASTER_LOG_POS=0"

while true; do
  shared::query "SELECT * FROM repl_demo.table1 ORDER BY id DESC LIMIT 10"
  sleep 1
done
