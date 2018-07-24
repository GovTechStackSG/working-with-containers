#!/bin/bash -ex

docker container run -ti --rm --publish 8000:8000 \
--network demo-net \
--name frontend frontend:latest $@
