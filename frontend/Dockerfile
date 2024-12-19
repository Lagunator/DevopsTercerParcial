FROM node:16

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm install web-vitals

EXPOSE 3000
CMD ["npx", "serve", "-s", "build"]
