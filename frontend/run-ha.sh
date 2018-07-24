#!/bin/bash -ex

sudo docker container run --net ha-webservers --rm --detach --publish 80 --name frontend1 \
--volume $(pwd):/usr/local/apache2/htdocs:z \
httpd:latest

sudo docker container run --net ha-webservers --rm --detach --publish 80 --name frontend2 \
--volume $(pwd):/usr/local/apache2/htdocs:z \
httpd:latest
