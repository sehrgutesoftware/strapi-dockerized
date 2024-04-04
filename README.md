# SehrGuteSoftware - Strapi Dockerized

### Configuration

The configuration is done via environment variables. The following variables are available:

```bash
# Server
HOST=0.0.0.0
PORT=1337
APP_KEYS="toBeModified1,toBeModified2"
API_TOKEN_SALT=tobemodified
ADMIN_JWT_SECRET=tobemodified
TRANSFER_TOKEN_SALT=tobemodified
JWT_SECRET=tobemodified

# Database
DATABASE_CLIENT=postgres
DATABASE_HOST=127.0.0.1
DATABASE_PORT=5432
DATABASE_NAME=strapi
DATABASE_USERNAME=strapi
DATABASE_PASSWORD=strapi
DATABASE_SSL=false
```

### Use in Docker Compose

```yaml
version: "3"
services:
  postgres:
    image: postgres:16-alpine
    env_file: .env
    volumes:
      - ./postgres/data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: ${DATABASE_NAME}
      POSTGRES_USER: ${DATABASE_USERNAME}
      POSTGRES_PASSWORD: ${DATABASE_PASSWORD}
  strapi:
    image: strapi-test:latest
    env_file: .env
    # Uncomment the following line to use the development environment
    # environment:
    #   NODE_ENV: development
    # command: ["npm", "run", "develop"]
    volumes:
      - ./strapi/config:/opt/app/config
      - ./strapi/api:/opt/app/src/api
      - ./.env:/opt/app/.env
    ports:
      - "1337:1337"
    depends_on:
      - postgres
```

Note that by default the `NODE_ENV` is set to `production`. If you want to use the development environment, you can uncomment the `environment` and `command` lines.
