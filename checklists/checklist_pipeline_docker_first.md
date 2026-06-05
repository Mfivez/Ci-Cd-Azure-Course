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

## Vérification par la pratique

- [ ] Exercice 1 terminé : Docker local
- [ ] Exercice 2 terminé : CI Docker-first
- [ ] Exercice 3 terminé : tags et registry
- [ ] Exercice 4 terminé : CD vers App Service
- [ ] Exercice 5 terminé : configuration et secrets
- [ ] Exercice 6 terminé : slots et rollback
- [ ] Exercice 7 terminé : IaC, CaC et Pipeline as Code
- [ ] Exercice 8 terminé : lecture du pipeline complet

