#!/bin/bash -ex

sudo docker container run --detach --publish 3000:3000 --name backend backend:latest
