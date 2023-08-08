#!/bin/bash

NETWORK='bhnoc'
HOST='python3'
PROJECT='python3'
DOCKER_TAG='bhnoc/python:latest'
docker stop python3
docker rm python3
docker run -d --name python3 \
              --network $NETWORK \
              -h python_base \
              --restart unless-stopped \
              $DOCKER_TAG
