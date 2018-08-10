#!/bin/bash

docker_pre=$1
docker_container=$2
docker_volumes=$3
test=$4

docker run --rm $docker_volumes $docker_container cp -R ./Auto-Test-Data/Cert-Store/* ./Cert-Store/

for i in $(seq 1 24); do
  docker run --rm $docker_volumes $docker_container cp -R Auto-Test-Data/$i/* Data/
  >&2 echo Running testscript on set $i
  ./Scripts/test.sh $docker_pre $docker_container "$docker_volumes" $test || exit 1
done

for i in $(seq 20 21); do
  docker run --rm $docker_volumes $docker_container cp -R Auto-Test-Data/$i/* Data/
  >&2 echo Running testscript on set $i
  ./Scripts/test_32.sh $docker_pre $docker_container "$docker_volumes" $test || exit 1
done

for i in $(seq 22 24); do
  docker run --rm $docker_volumes $docker_container cp -R Auto-Test-Data/$i/* Data/
  >&2 echo Running testscript on set $i
  ./Scripts/test.sh $docker_pre $docker_container "$docker_volumes" $test || exit 1
done

