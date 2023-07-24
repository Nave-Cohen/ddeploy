FROM node:20-alpine
ARG GIT BRANCH COMMIT BUILD RUN PORT

WORKDIR /app
RUN apk update && apk add git

RUN git clone -b $BRANCH $GIT /app/$COMMIT/

WORKDIR /app/$COMMIT
RUN $BUILD
COPY . .

EXPOSE $PORT
CMD $RUN
