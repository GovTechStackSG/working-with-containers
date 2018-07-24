#!/bin/bash -x

docker network create demo-net

docker container run --rm -ti --publish 3000:3000 \
--network demo-net \
--name backend backend:latest $@
