FROM node:20-alpine AS tester
WORKDIR /app

COPY src/package*.json ./

RUN npm ci

COPY src/ ./

RUN npm test



FROM node:20-alpine AS production
WORKDIR /app

COPY src/package*.json ./

RUN npm ci --only=production

COPY src/ ./

EXPOSE 3000

CMD ["npm", "start"]