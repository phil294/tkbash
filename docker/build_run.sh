#!/bin/bash
set -e
image_name=debian_tkbash
docker rmi -f "$image_name"
docker build -t "$image_name" .
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge - # see https://stackoverflow.com/questions/16296753
docker run --rm -it -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH "$image_name"