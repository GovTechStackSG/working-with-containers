#!/bin/bash -ex


sudo docker container rm --force frontend frontend1 frontend2 backend backend1 backend2 frontend-lb backend-lb
sudo docker images rm --force backend:latest
sudo docker network rm ha-webservers
sudo docker network create ha-webservers
