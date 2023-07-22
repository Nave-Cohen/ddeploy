FROM node:20-alpine
ARG GIT
ARG BUILD
ARG RUN

WORKDIR /app
RUN apk update && apk add git

RUN git clone $GIT /app/repo/

WORKDIR /app/repo
RUN $BUILD
COPY . .

EXPOSE 3000
CMD $RUN
