FROM node:22-alpine
RUN apk update && apk upgrade --no-cache
WORKDIR /app

COPY package.json ./
COPY app.js ./

EXPOSE 3000

CMD ["node", "app.js"]
