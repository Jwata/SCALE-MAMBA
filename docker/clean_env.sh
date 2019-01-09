#!/bin/bash

stop_players() {
  volumes=$(echo $DOCKER_VOLS)
  players=$(docker run --rm -a STDOUT $volumes $CONTAINER cat Data/NetworkData.txt | sed -n 2p)
  last_player=$(($players - 1))
  for i in $(seq 0 $last_player); do
    docker stop -t 0 ${DOCKER_PRE}-player-$i > /dev/null
  done
}

stop_players
docker container rm ${DOCKER_DUMMY}
docker volume rm ${VOL_CERTS} ${VOL_PROGS} ${VOL_DATA} ${VOL_TESTDATA}
docker network rm ${DOCKER_NET}
