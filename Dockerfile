# -|----------------------------------------------------------------------------
#  | Development image
# -|----------------------------------------------------------------------------
FROM node:20-alpine AS dev
WORKDIR /app
ENV NODE_ENV=development

COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json ./
COPY public ./public

ENV APP_KEYS="development - don't care"
ENV JWT_SECRET="development - don't care"
ENV ADMIN_JWT_SECRET="development - don't care"
ENV API_TOKEN_SALT="development - don't care"

ENTRYPOINT [ "npm", "run", "develop" ]

# -|----------------------------------------------------------------------------
#  | Production base image
# -|----------------------------------------------------------------------------
FROM node:20-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

RUN apk add --no-cache vips-dev

WORKDIR /app
RUN chown node:node /app
USER node

COPY --from=dev --chown=node:node /app .
COPY --chown=node:node server.js ./

EXPOSE 1337
ENTRYPOINT [ "node", "server.js" ]
