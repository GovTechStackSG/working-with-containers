#!/bin/bash -e

sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend1 mywebserver:latest

sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend2 mywebserver:latest
