## Redis Dockerfile


This repository contains **Dockerfile** of [Vault](https://www.vaultproject.io//) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/dockerfile/vault/) published to the ECR  [ECR]().


### Base Docker Image

* [dockerfile/rocky8]( https://.dkr.ecr.us-east-1.amazonaws.com/rockylinux8.5:latest)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https:///vault:latest)) from public [Docker Hub Registry](https://.dkr.ecr.us-east-1.amazonaws.com): `docker pull https://.dkr.ecr.us-east-1.amazonaws.com/vault:latest`

   (alternatively, you can build an image from Dockerfile: `docker build -t bhnoc/vault:lastest  -f Dockerfile .`)


### Usage

#### Build `vault:latest`

docker build -t bhnoc/vault:lastest  -f Dockerfile .

#### Run `vault-server` Server

docker run -d \
	--add-host=vault.bhnoc.org:127.0.0.1 \
	-p8200:8200 \
	--cap-add=IPC_LOCK \
	--name vault12_test \
	--network $NETWORK \
	-h vault12_test \
	--restart unless-stopped \
	-v /docker/vault/:/etc/vault \
	-v /docker/keys:/var/www/keys \
	-v /var/log/docker/vault/:/var/log/vault/ \
	$DOCKER_TAG
