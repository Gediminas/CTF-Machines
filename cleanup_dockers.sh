#!/usr/bin/env bash

read -p "This will DELETE ALL dockers, images, and unused networks. Are you sure you wish to continue? Type 'yes' to continue..."
if [ "$REPLY" != "yes" ]; then
   exit
fi

# docker rm fr-srv1 fr-proxy fr-client --force
# docker rmi frtest:deb1 --force

docker rm $(docker ps -a -q) --force
docker rmi $(docker images -a -q) --force
docker system prune -a -f

docker images
docker ps -a

