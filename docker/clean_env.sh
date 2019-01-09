#!/bin/bash

docker container rm ${DOCKER_DUMMY}
docker volume rm ${VOL_CERTS} ${VOL_PROGS} ${VOL_DATA} ${VOL_TESTDATA}
docker network rm ${DOCKER_NET}
