#!/bin/bash -ex


sudo docker container run --net ha-webservers --detach --publish 8080:8080 --name frontend-lb \
--volume $(pwd):/usr/local/etc/haproxy/cfg:z \
haproxy:latest \
haproxy -f /usr/local/etc/haproxy/cfg/frontend.cfg
