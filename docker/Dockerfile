FROM node:18-alpine

WORKDIR /app

COPY ProyectoBackend/package*.json ./

RUN npm install --production

COPY ProyectoBackend/ .

EXPOSE 3000

CMD ["node", "index.js"]
