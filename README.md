# CI/CD Docker-first avec Azure DevOps

Le cours suit une application conteneurisée appelée **Croissant API**.

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
   ↓
Rollback possible
```

## Commencer

- `00_cours_complet.md` contient le cours en un seul fichier.
- `cours/` contient les chapitres séparés.
- Les encadrés **À pratiquer maintenant** indiquent précisément quand faire chaque exercice.
- `00_points_de_pratique.md` récapitule tous les exercices dans l’ordre.
- `exercices/` contient les énoncés.
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

Certaines étapes Azure réelles, comme Azure Container Registry, App Service ou les slots, nécessitent une souscription Azure. Les exercices indiquent une variante de lecture lorsque l’exécution cloud n’est pas disponible.
