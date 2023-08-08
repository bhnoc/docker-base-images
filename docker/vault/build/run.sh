#!/bin/bash

NETWORK='bhnoc'
HOST='vault'
PROJECT='vault'
DOCKER_TAG='bhnoc/vault:latest'
CONTAINER='vault'
LOG_PATH='/home/bhnoc/logs'
mkdir -p $LOG_PATH/$CONTAINER/
APP_PATH='/home/bhnoc/git/base/docker/'
docker stop vault
docker rm vault
docker run -d \
	--add-host=vault.bhnoc.org:127.0.0.1 \
	-p8200:8200 \
	--cap-add=IPC_LOCK \
	--name vault \
	--network bhnoc \
	-h vault \
	--restart unless-stopped \
	-v /home/bhnoc/configs/vault:/etc/vault \
	-v /home/bhnoc/docker/keys:/var/www/keys \
	-v /home/bhnoc/logs/vault:/var/log/vault/ \
	-v $APP_PATH/configs/$CONTAINER/config:/opt/env/live/config \
	-v $APP_PATH/configs/$CONTAINER/logs:/opt/env/live/logs \
	-v $APP_PATH/$CONTAINER/app:/opt/env/live/app \
	$DOCKER_TAG
