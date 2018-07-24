#!/bin/bash -x
FRONTEND_PORT=${FRONTEND_PORT:-8000}
BACKEND_HOSTNAME=${BACKEND_HOSTNAME:-backend}
BACKEND_PORT=${BACKEND_PORT:-3000}

sed -i -e "s/FRONTEND_PORT/${FRONTEND_PORT}/" \
-e "s/BACKEND_HOSTNAME/${BACKEND_HOSTNAME}/" \
-e "s/BACKEND_PORT/${BACKEND_PORT}/" \
/etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
