# Corrigé 1 — Lancer Croissant API en local avec Docker

```bash
npm test

docker build -t croissant-api:local .

docker run --rm -p 8080:8080 \
  -e ENVIRONMENT_NAME=local \
  -e APP_VERSION=local \
  croissant-api:local
```

Dans un autre terminal :

```bash
curl http://localhost:8080/health
curl http://localhost:8080/version
```

Réponse attendue pour `/health` :

```json
{"status":"ok"}
```
