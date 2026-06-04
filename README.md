# Cours CI/CD avec Azure DevOps

Ce cours présente le cycle de vie d’une application moderne avec Azure DevOps : gestion du code, intégration continue, artefacts, déploiement continu, environnements, secrets, approbations, slots de déploiement et rollback.

Le parcours se lit dans l’ordre des dossiers `J1` à `J4`. Chaque dossier contient des chapitres, des exercices et des corrigés.

## Parcours

```text
J1  Fondations, Git, Azure Repos, CI/CD et YAML
J2  Intégration continue : agents, build, tests, qualité, artefacts
J3  Déploiement continu : environnements, Azure App Service, Dev et Staging
J4  Production : secrets, approbations, slots, swap, rollback, bonnes pratiques
```

## Fichiers principaux

```text
00_table_des_matieres.md
J1_fondations_ci_azure_devops/
J2_integration_continue/
J3_deploiement_continu_environnements/
J4_production_securisation_rollback/
demos/
annexes/
```

## Application fil rouge

Les exemples utilisent une petite API Node.js avec une route `/` et une route `/health`.

```text
/       → message de l’application
/health → vérification rapide utilisée après déploiement
```

Cette application reste simple afin de se concentrer sur la chaîne CI/CD plutôt que sur le code métier.
