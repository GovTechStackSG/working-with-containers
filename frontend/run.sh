#!/bin/bash -ex

sudo docker container run --detach --rm --publish 8080:80 \
--name frontend --volume $(pwd):/usr/local/apache2/htdocs:z \
httpd:latest
