#!/bin/bash

docker_pre=$1
docker_container=$2
docker_volumes=$3
shift 3

HERE=$(cd `dirname $0`; pwd)

. $HERE/run-common.sh

run_player $docker_pre $docker_container "$docker_volumes" ./Player.x ${1:-test_all} || exit 1
