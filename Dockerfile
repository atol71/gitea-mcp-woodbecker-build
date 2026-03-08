FROM node:20-alpine AS build
WORKDIR /app

RUN apk add --no-cache git python3 make g++ libc-dev

ARG GITHUB_TOKEN
RUN git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app

COPY --from=build /app/dist ./dist
COPY package*.json ./
RUN npm install --omit=dev

CMD ["node", "dist/index.js"]
