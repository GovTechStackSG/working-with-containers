#!/bin/bash -e

sudo docker container run --detach --publish 3000:3000 --name webserver mywebserver:latest
