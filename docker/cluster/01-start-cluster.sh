#!/usr/bin/bash

export -p JENKINS_PUB_KEY=$(cat jenkins/.ssh/jenkins.pub)
printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${JENKINS_PUB_KEY}"

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Clean containers: "
docker-compose rm -s -f -v
printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Build agents image"
docker-compose -f docker-compose-agents.yml build

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start jenkins and Docker registry"
docker-compose \
    -f docker-compose.yml \
    up -d \
    --no-deps \
    --build \
    --force-recreate

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Push agents image to docker registry"
docker-compose -f docker-compose-agents.yml push
