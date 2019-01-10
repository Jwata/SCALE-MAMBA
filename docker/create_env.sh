#!/bin/bash

NETWORK=172.29.0.0/16

docker network create --subnet ${NETWORK} ${DOCKER_NET}
docker container create --name ${DOCKER_DUMMY} ${DOCKER_VOLS} ${CONTAINER}
docker cp ../Programs ${DOCKER_DUMMY}:/scale-mamba/
docker cp ../Auto-Test-Data/Cert-Store ${DOCKER_DUMMY}:/scale-mamba/
for f in `ls ../Auto-Test-Data/${MPC_SETTING}`;do
	docker cp ../Auto-Test-Data/${MPC_SETTING}/$f ${DOCKER_DUMMY}:/scale-mamba/Data
done
