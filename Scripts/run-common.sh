run_player() {
    docker_pre=$1
    docker_container=$2
    docker_volumes=$3
    bin=$4
    shift 4
    trap 'echo interrupting players' SIGINT
    if ! test -e Scripts/logs; then
        mkdir Scripts/logs
    fi
    params="$*"
    rem=$(($players - 2))
    last_player=$(($players - 1))

    for i in $(seq 0 $last_player); do
      echo "starting up container $i"
      docker run --rm -d $docker_volumes --network $docker_pre-testnet --ip 172.29.0.10$(($i+1)) --name $docker_pre-player-$i $docker_container tail -f /dev/null
    done
    for i in $(seq 0 $rem); do
      echo "trying with player $i"
      >&2 echo "running player $i"
       docker exec $docker_pre-player-$i $bin $i $params 2>&1 >Scripts/logs/$i &

    done
    >&2 echo "running player $last_player"
    docker exec $docker_pre-player-$last_player $bin $last_player $params  2>&1 >Scripts/logs/$last_player
    result=$?

    for i in $(seq 0 $last_player); do
      docker stop -t 0 $docker_pre-player-$i > /dev/null
    done
    trap SIGINT
    docker cp $docker_pre-dummy:/scale-mamba/Data/Memory-P0 Data/Memory-P0
    docker cp $docker_pre-dummy:/scale-mamba/Data/SharingData.txt Data/
    return $result
}

declare -i players=$(docker run --rm -a STDOUT $docker_volumes $docker_container cat Data/NetworkData.txt | sed -n 2p)
