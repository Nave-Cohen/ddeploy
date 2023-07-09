FROM node:20-alpine
ARG GIT

WORKDIR /app
RUN apk update && apk add git

RUN git clone $GIT /app/repo/

WORKDIR /app/repo
RUN npm install
COPY . .

EXPOSE 3000
CMD npm start
