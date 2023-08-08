#!/bin/sh


echo "System is Ready"
start_services() {
redis-server /etc/redis/redis.conf
  while [[ $RESULT != *"already in use"* ]]; do
    RESULT=$(redis-server /etc/redis/redis.conf)
    echo $RESULT
    sleep 10
  done
}
start_vault

tail -f /dev/null
