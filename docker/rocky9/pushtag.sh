#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d")
ENVIRONMENT='latest'
CONTAINER='vault'

docker tag bhnoc/$CONTAINER:$ENVIRONMENT 775519406652.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:$ENVIRONMENT-$TIMESTAMP
docker tag bhnoc/$CONTAINER:$ENVIRONMENT 775519406652.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:latest
docker push 775519406652.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:$ENVIRONMENT-$TIMESTAMP
docker push 775519406652.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:latest
