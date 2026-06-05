# Corrigé 5 — Classer configuration et secrets

| Valeur | Emplacement adapté |
|---|---|
| `imageRepository=croissant-api` | YAML |
| `APP_SERVICE_NAME=croissant-api-prod` | Variable Group |
| `DATABASE_PASSWORD=...` | Key Vault |
| `ENVIRONMENT_NAME=production` | Application Settings ou Variable Group |
| Connexion permettant au pipeline de déployer dans Azure | Service Connection Azure Resource Manager |
| Connexion permettant au pipeline de pousser dans ACR | Service Connection Docker Registry / ACR |
| `WEBSITES_PORT=8080` | Application Settings |
| `LOG_LEVEL=debug` | Application Settings ou Variable Group |
