#!/bin/bash -ex


sudo docker container run --net ha-webservers --detach --publish 3000:3000 --name backend-lb \
--volume $(pwd):/usr/local/etc/haproxy/cfg:z \
haproxy:latest \
haproxy -f /usr/local/etc/haproxy/cfg/backend.cfg
