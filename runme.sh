#!/usr/bin/env bash

docker_name=jupyter

case $1 in

  build)
    docker build . -t $docker_name --platform linux/x86_64
    ;;

  run)
    docker run \
      -v "$PWD"/workspace:/workspace \
      -d \
      -p 8888:8888 \
      --name $docker_name \
      $docker_name
    ;;

  bash)
    docker exec -it $docker_name /bin/bash
    ;;

  stop)
    docker stop $docker_name
    ;;

  *)
    echo "Unknown command. Please provide valid command"
    ;;
esac
