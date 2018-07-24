#!/bin/bash -ex

docker container run -ti --rm --publish 8000:8000 \
--network demo-net \
-u 30000 \
--name frontend frontend:latest $@
