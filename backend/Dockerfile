FROM node:latest

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN npm install

RUN chgrp 0 /usr/src/app

EXPOSE 3000

CMD npm start
