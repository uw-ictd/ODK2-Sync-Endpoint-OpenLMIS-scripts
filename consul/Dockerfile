FROM node:8

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install

COPY config.json registration.js register.sh /usr/src/app/

CMD ./register.sh