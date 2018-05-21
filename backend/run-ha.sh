#!/bin/bash -ex

sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend1 backend:latest

sudo docker container run --net ha-webservers --detach --rm --publish 3000 --name backend2 backend:latest
