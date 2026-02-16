FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
CMD [ "npm", "start" ]
LABEL org.opencontainers.image.source="https://github.com/amrkedra/MERN-Full-project"
