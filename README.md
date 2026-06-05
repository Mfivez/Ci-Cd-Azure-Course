# CI/CD Docker-first avec Azure DevOps

Le fil rouge est une API conteneurisée : **Croissant API**.

```text
GitHub
   ↓
Azure Pipelines
   ↓
Tests
   ↓
Image Docker
   ↓
Azure Container Registry
   ↓
Azure App Service for Containers
   ↓
Staging
   ↓
Production
```

## Lecture

- `00_cours_complet.md` contient le cours en un seul fichier.
- `cours/` contient les chapitres séparés.
- `exercices/` contient les exercices.
- `corriges/` contient les corrigés.
- `demos/croissant-api-start.zip` contient l’application de départ.
- `demos/croissant-api-solution.zip` contient l’application avec les pipelines d’exemple.

## Démarrage rapide de l’application

```bash
cd demos/croissant-api-start
npm test
docker build -t croissant-api:local .
docker run --rm -p 8080:8080 croissant-api:local
curl http://localhost:8080/health
```

## Chaîne finale

```text
Code GitHub
   → CI Azure Pipelines
   → Docker build
   → Push ACR
   → Deploy App Service
   → Slot staging
   → Approval production
   → Swap
   → Rollback possible
```
