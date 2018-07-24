FROM node:latest

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN npm install

RUN chmod -R a+rwX /usr/src/app

EXPOSE 3000

CMD npm start
