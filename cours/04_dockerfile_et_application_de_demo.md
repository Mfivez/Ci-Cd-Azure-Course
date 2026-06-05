# Chapitre 4 — Dockerfile et application de démo

Croissant API est une petite application Node.js sans dépendance externe. Elle utilise le module HTTP natif de Node.js.

Structure :

```text
croissant-api/
   ├── src/
   │   ├── app.js
   │   └── server.js
   ├── test/
   │   └── app.test.js
   ├── Dockerfile
   ├── .dockerignore
   ├── docker-compose.yml
   └── package.json
```

## Lancer l’application localement

```bash
npm test
npm start
```

L’application écoute par défaut sur le port `8080`.

```bash
curl http://localhost:8080/health
```

Réponse attendue :

```json
{
  "status": "ok"
}
```

## Construire l’image Docker localement

```bash
docker build -t croissant-api:local .
```

Lancer le conteneur :

```bash
docker run --rm -p 8080:8080 \
  -e ENVIRONMENT_NAME=local \
  -e APP_VERSION=local \
  croissant-api:local
```

Tester :

```bash
curl http://localhost:8080/version
```

Réponse typique :

```json
{
  "name": "croissant-api",
  "version": "local",
  "environment": "local"
}
```

## Dockerfile

Le Dockerfile est la recette de construction de l’image.

```dockerfile
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

COPY package*.json ./
RUN npm install --omit=dev

COPY src ./src

EXPOSE 8080

CMD ["node", "src/server.js"]
```

Lecture ligne par ligne :

| Ligne | Rôle |
|---|---|
| `FROM node:20-alpine` | image de base avec Node.js |
| `WORKDIR /app` | dossier de travail dans l’image |
| `ENV PORT=8080` | port par défaut de l’application |
| `COPY package*.json ./` | copie des métadonnées npm |
| `RUN npm install --omit=dev` | installe les dépendances de production |
| `COPY src ./src` | copie le code applicatif |
| `EXPOSE 8080` | documente le port exposé |
| `CMD ...` | commande lancée au démarrage du conteneur |

## `.dockerignore`

Le fichier `.dockerignore` évite d’envoyer des fichiers inutiles au build Docker.

```text
node_modules
.git
.azure
coverage
*.log
.env
```

Cela accélère le build et évite d’inclure des fichiers sensibles ou inutiles dans l’image.

## Docker Compose

Pour lancer la démo plus facilement :

```yaml
services:
  api:
    build: .
    image: croissant-api:local
    ports:
      - "8080:8080"
    environment:
      ENVIRONMENT_NAME: local
      APP_VERSION: docker-compose
      LOG_LEVEL: debug
```

Commande :

```bash
docker compose up --build
```

## Ce que le pipeline devra reproduire

Localement, on fait :

```bash
npm test
docker build -t croissant-api:local .
docker run -p 8080:8080 croissant-api:local
```

Dans Azure Pipelines, on va automatiser la même logique :

```text
checkout GitHub
   ↓
npm test
   ↓
docker build
   ↓
smoke test du conteneur
```

Le pipeline ne fait donc pas de magie. Il automatise ce qui peut déjà être fait localement.
---

## À pratiquer maintenant — Exercice 1 : lancer Croissant API avec Docker

Avant de continuer, ouvrez l’application de départ et réalisez l’exercice :

- Application : `demos/croissant-api-start/`
- Énoncé : `exercices/01_docker_local.md`
- Corrigé : `corriges/01_docker_local_corrige.md`

À la fin de la pratique, vous devez avoir vérifié que :

```text
npm test passe
l’image croissant-api:local est construite
le conteneur démarre sur le port 8080
/health répond correctement
/version affiche les variables transmises au conteneur
```

Reprenez au chapitre 5 lorsque l’application fonctionne dans un conteneur local.
