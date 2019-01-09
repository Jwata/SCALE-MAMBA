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
    for i in $(seq 0 $last_player); do
      echo "starting up player $i"
      docker run --rm -d $volumes --network $DOCKER_NET --ip 172.29.0.10$(($i+1)) --name ${DOCKER_PRE}-player-$i $CONTAINER tail -f /dev/null
    done
    # for i in $(seq 0 $rem); do
    #   echo "trying with player $i"
    #   >&2 echo Running ../$bin $i $params
    #   docker exec $docker_pre-player-$i $bin $i $params 2>&1 >Scripts/logs/$i &
    # done
    # >&2 echo Running ../$bin $last_player $params
    # ./$bin $last_player $params > Scripts/logs/$last_player 2>&1 || return 1
}

killall Player.x 
sleep 0.5

declare -i players=$(docker run --rm -a STDOUT $volumes $CONTAINER cat Data/NetworkData.txt | sed -n 2p)

#. Scripts/setup.sh
