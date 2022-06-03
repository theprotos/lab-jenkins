#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Clean containers"
docker-compose rm -s -f -v

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Build agents image"
docker-compose -f docker-compose-agents.yml build

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Push agents image to docker registry"
docker-compose -f docker-compose-agents.yml push

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start jenkins and Docker registry"
docker-compose \
    -f docker-compose.yml \
    up -d \
    --no-deps \
    --build \
    --force-recreate
