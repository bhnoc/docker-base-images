!/bin/bash
TIMESTAMP=$(date +"%Y%m%d")
ENVIROMENT='latest'
CONTAINER='redis'
ECR='redis'
echo "docker tag bhnoc/$CONTAINER:$ENVIROMENT bhnoc.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:$ENVIROMENT-$TIMESTAMP"

docker tag bhnoc/$CONTAINER:$ENVIROMENT bhnoc.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:$ENVIROMENT-$TIMESTAMP
docker tag bhnoc/$CONTAINER:$EVNIROMENT bhnoc.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:latest
docker push bhnoc.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:$ENVIROMENT-$TIMESTAMP
docker push bhnoc.dkr.ecr.us-east-1.amazonaws.com/$CONTAINER:latest

