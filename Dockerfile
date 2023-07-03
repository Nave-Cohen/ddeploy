FROM node:20-alpine
WORKDIR /app
RUN git clone https://github.com/Nave-Cohen/Web-Project.git /app/data
WORKDIR /app/data
RUN npm install

EXPOSE 3000
CMD npm start