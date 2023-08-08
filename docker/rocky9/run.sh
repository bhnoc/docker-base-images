#!/bin/bash

NETWORK='bhnoc'
HOST='rocky9'
PROJECT='rocky9'
DOCKER_TAG='bhnoc/rocky9:latest'
docker stop rocky9
docker rm rocky9
docker run -d --name rocky9 \
              --network $NETWORK \
              -h rocky9 \
              --restart unless-stopped \
              $DOCKER_TAG
