# Croissant API

Application de démonstration pour un pipeline CI/CD Docker-first.

## Lancer les tests

```bash
npm test
```

## Lancer localement

```bash
npm start
curl http://localhost:8080/health
```

## Docker

```bash
docker build -t croissant-api:local .
docker run --rm -p 8080:8080 -e ENVIRONMENT_NAME=local -e APP_VERSION=local croissant-api:local
```

## Docker Compose

```bash
docker compose up --build
```
