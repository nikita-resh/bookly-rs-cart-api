# Base
FROM node:12-alpine as base

# creates app directory
WORKDIR /app

# Dependencies
FROM base as dependencies

# packeges installation based on package.json and package-lock.json files
COPY package*.json ./
RUN npm install

# Build
FROM dependencies as build

WORKDIR /app
COPY . .
# bulding application
RUN npm run build

# Application
FROM node:12-alpine as application

ENV NODE_ENV=production

# copping directories from build
COPY --from=build /app/package*.json ./
RUN npm install
COPY --from=build /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
