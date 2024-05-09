# -|----------------------------------------------------------------------------
#  | Intermediate image for building the application.
# -|----------------------------------------------------------------------------
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# -|----------------------------------------------------------------------------
#  | Final image containing only the files required to run in production.
# -|----------------------------------------------------------------------------
FROM node:20-alpine AS production
RUN apk add --no-cache vips-dev

WORKDIR /app
USER node
ENV NODE_ENV=production

COPY --from=builder --chown=node:node /app/package.json .
COPY --from=builder --chown=node:node /app/dist dist
COPY --from=builder --chown=node:node /app/node_modules node_modules
COPY --chown=node:node public ./public

EXPOSE 1337
ENTRYPOINT [ "npm", "run", "start" ]
