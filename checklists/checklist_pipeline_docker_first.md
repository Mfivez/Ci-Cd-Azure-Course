# Checklist pipeline Docker-first

- Le repo GitHub contient le code, le Dockerfile et `azure-pipelines.yml`.
- Le pipeline se déclenche sur pull request vers `main`.
- Le pipeline lance les tests avant le build Docker.
- Le pipeline construit l’image Docker.
- Le pipeline démarre un conteneur et vérifie `/health`.
- Les images poussées dans ACR ont un tag traçable.
- Le déploiement dev utilise l’image venant d’ACR.
- Le staging utilise un slot ou un App Service séparé.
- La production est protégée par approval/check.
- Les secrets ne sont pas dans Git ni dans le Dockerfile.
- Les App Settings configurent l’application au runtime.
- Le rollback est documenté.
