# Corrigé 8 — Lire le pipeline complet end-to-end

1. Le pipeline est déclenché par un push sur `main`, selon la configuration `trigger`.
2. Le stage de CI est le stage qui installe les dépendances, lance les tests, construit l’image Docker et la pousse dans le registry.
3. Les tests sont exécutés sur l’agent Azure Pipelines, généralement `ubuntu-latest`.
4. L’image est construite et poussée dans le stage de CI, avec la tâche Docker ou des commandes Docker équivalentes.
5. Le tag utilisé est généralement `$(Build.BuildId)`, ce qui donne une version unique pour chaque run.
6. Le stage de déploiement staging configure Azure App Service ou son slot staging pour utiliser cette image.
7. Le smoke test vérifie rapidement que l’application répond après déploiement, par exemple via `/health`.
8. L’environnement `production` doit être protégé par une approbation.
9. La commande de swap est :

```bash
az webapp deployment slot swap   --name <app-name>   --resource-group <resource-group>   --slot staging   --target-slot production
```

10. Pour revenir en arrière, on refait un swap inverse : l’ancienne version, restée dans le slot staging après le premier swap, redevient la production.

Schéma complété :

```text
GitHub
  ↓
Azure Pipelines
  ↓
npm test
  ↓
docker build + docker push
  ↓
Azure Container Registry
  ↓
Azure App Service staging
  ↓
Smoke test
  ↓
Approval + swap
  ↓
Production
```
