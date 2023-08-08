#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d")
ENVIRONMENT='latest'
CONTAINER='php8'
ECR='php8'
docker tag bhnoc/php8:latest ghcr.io/bhnoc/php8:latest
docker push ghcr.io/bhnoc/php8:latest
