volumes=$(echo $DOCKER_VOLS)

run_player() {
    bin=$1
    shift
    if ! test -e Scripts/logs; then
        mkdir Scripts/logs
    fi
    params="-f 1 $*"
    rem=$(($players - 2))
    last_player=$(($players - 1))

    # run players
    for i in $(seq 0 $last_player); do
      echo "starting up player $i"
      docker run --rm -d $volumes --network $DOCKER_NET --ip 172.29.0.10$(($i+1)) --name ${DOCKER_PRE}-player-$i $CONTAINER tail -f /dev/null
    done

    # run program on each container
    for i in $(seq 0 $rem); do
      echo "trying with player $i"
      >&2 echo Running ../$bin $i $params
      docker exec ${DOCKER_PRE}-player-$i $bin $i $params 2>&1 >Scripts/logs/$i &
    done
    echo "trying with player $last_player"
    >&2 echo Running ../$bin $last_player $params
    docker exec ${DOCKER_PRE}-player-$last_player ./$bin $last_player $params > Scripts/logs/$last_player 2>&1 || return 1
    result=$?

    # extract memory data
    for i in $(seq 0 $last_player); do
      docker cp ${DOCKER_PRE}-player-$i:/scale-mamba/Data/Memory-P$i Data/Memory-P$i
    done
    docker cp ${DOCKER_PRE}-player-0:/scale-mamba/Data/SharingData.txt Data/
    return $result
}

declare -i players=$(docker run --rm -a STDOUT $volumes $CONTAINER cat Data/NetworkData.txt | sed -n 2p)

#. Scripts/setup.sh
