#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d")
ENVIRONMENT='latest'
CONTAINER='python3'
ECR='python3'
docker tag bhnoc/python3:latest ghcr.io/bhnoc/python3:latest
docker push bhnoc/python3:latest ghcr.io/bhnoc/python3:latest
