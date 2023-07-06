FROM node:20-alpine
ARG GIT
ARG REF

WORKDIR /app
RUN apk update && apk add git

ADD $REF version.json

RUN git clone $GIT /app/repo/

WORKDIR /app/repo
RUN npm install
COPY . .

EXPOSE 3000
CMD npm start
