#!/bin/bash

NETWORK='bhnoc'
HOST='redis'
IP='192.168.24.100'
PROJECT='redis'
DOCKER_TAG='bhnoc/redis:lastest'
CONTAINER='redis'
mkdir -p /docker/logs/$CONTAINER/
docker stop redis1
docker rm redis1
docker run -d \
	--add-host=redis.bhnoc.org:127.0.0.1 \
	-p6379:6379 \
	--cap-add=IPC_LOCK \
	--name redis1 \
	--network $NETWORK \
	-h redis1 \
	--restart unless-stopped \
	-v /docker/redis/data:/data \
	-v /docker/redis/etc/:/etc/redis \
	$DOCKER_TAG
