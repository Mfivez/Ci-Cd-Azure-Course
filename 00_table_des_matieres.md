# Table des matières — cours 4 jours

## Jour 1 — Fondations DevOps, CI/CD et YAML

1. Pourquoi automatiser le cycle de vie applicatif ?
2. Azure DevOps en vue d’ensemble
3. Différence entre CI, CD, déploiement et environnement
4. Pipeline : définition et vocabulaire
5. YAML vs Classic Pipeline
6. Anatomie d’un pipeline Azure DevOps
7. Triggers, stages, jobs, steps
8. Agents et pools, sans rentrer dans le self-hosted avancé
9. Premier pipeline minimal
10. Atelier : lire et expliquer un pipeline YAML

## Jour 2 — CI concrète : build, tests, qualité et artefacts

1. Rappel du jour 1
2. Objectif de la CI
3. Restaurer les dépendances
4. Compiler / builder
5. Lancer les tests
6. Introduire le Shift Left
7. Publier les résultats de tests
8. Produire un artefact
9. Publier un artefact dans Azure DevOps
10. Branch policies et validation de PR
11. Atelier : construire un pipeline CI complet

## Jour 3 — CD et environnements Azure

1. Rappel : on part d’un artefact validé
2. Objectif du CD
3. Continuous Delivery vs Continuous Deployment
4. Chaîne de promotion : Dev → Test/Staging → Prod
5. Environments Azure DevOps
6. Variables par environnement
7. Service Connections
8. Déploiement vers Azure App Service
9. Déploiement Dev automatique
10. Déploiement Test/Staging après Dev
11. Smoke tests
12. Atelier : compléter un pipeline multi-stage Dev → Staging

## Jour 4 — Production propre : sécurité, approvals, slots et rollback

1. Pourquoi ne pas déployer directement en production ?
2. Approvals and Checks
3. Branch control et approbation humaine
4. Variables, secrets et Variable Groups
5. Azure Key Vault en introduction
6. Blue/Green avec Deployment Slots
7. Déploiement sur slot staging
8. Swap staging → production
9. Rollback
10. Monitoring léger post-déploiement
11. Templates YAML en introduction
12. Checklist finale CI/CD
13. Atelier final : pipeline complet jusqu’à production
