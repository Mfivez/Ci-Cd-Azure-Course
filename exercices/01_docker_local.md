# Exercice 1 — Lancer Croissant API en local avec Docker

À partir du dossier `demos/croissant-api-start`, exécuter les étapes suivantes.

1. Lancer les tests Node.js.
2. Construire l’image Docker avec le tag `croissant-api:local`.
3. Lancer un conteneur sur le port `8080`.
4. Vérifier `/health` avec `curl`.
5. Afficher `/version` et observer les variables `ENVIRONMENT_NAME` et `APP_VERSION`.

Commandes à compléter :

```bash
npm ______

docker build -t ______ .

docker run --rm -p ____:____ \
  -e ENVIRONMENT_NAME=local \
  -e APP_VERSION=local \
  ______

curl http://localhost:8080/______
curl http://localhost:8080/______
```
