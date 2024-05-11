# Strapi Dockerized

This repository provides development and production images for Strapi.

## Development

The development image can be used as-is, for example in a `compose.yaml`. The `src`, `config` and `public` directories from the source folder of your Strapi project must be mounted into the container.

```yaml
version: "3"
services:
  postgres:
    image: postgres:16-alpine
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: strapi
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: strapi
      PGDATA: /var/lib/postgresql/data/pgdata
  strapi:
    image: ghcr.io/sehrgutesoftware/strapi-dockerized/dev:latest
    ports:
      - "1337:1337"
    environment:
      DATABASE_CLIENT: postgres
      DATABASE_HOST: postgres
      DATABASE_PORT: 5432
      DATABASE_NAME: strapi
      DATABASE_USERNAME: strapi
      DATABASE_PASSWORD: strapi
      # See https://docs.strapi.io/dev-docs/configurations/environment for all environment variables
    volumes:
      - ${PWD}/src:/app/src
      - ${PWD}/config:/app/config
      - ${PWD}/public:/app/public
    depends_on:
      - postgres
volumes:
  postgres-data:
```

## Production

The production image serves as a base image, which can be used in a Dockerfile to build an application-specific production docker image:

```Dockerfile
FROM ghcr.io/sehrgutesoftware/strapi-dockerized/prod:4.22.0
COPY --chown=node:node . .
RUN npm run build
```

Configuration values must be injected at run time via environment variables or a .env file.
