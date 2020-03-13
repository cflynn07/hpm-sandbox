#!/bin/bash

container_name="mysql_master"
check_container() {
  docker inspect "$container_name" &>/dev/null
}

echo "waiting for $container_name to start..."
while ! check_container; do
  echo "$container_name not found"
  sleep 1
done

CID=$(docker inspect $container_name -f "{{ .Id }}")
echo "found $container_name, ID: $CID"

cat <<- EOF | mysql -u root -h "$container_name"
SHOW DATABASES;
EOF
