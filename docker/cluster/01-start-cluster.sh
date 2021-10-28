#!/usr/bin/bash

docker-compose rm -s -f -v

docker-compose \
    -f docker-compose.yml \
    up -d \
    --no-deps \
    --build \
    --force-recreate
