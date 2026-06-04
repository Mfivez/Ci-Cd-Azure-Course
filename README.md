# CI/CD avec Azure DevOps

Ce cours suit une application web simple appelée **Croissant API**. Elle commence comme un petit projet local, puis elle est versionnée, testée, construite, empaquetée et déployée progressivement avec Azure DevOps.

Le fil conducteur reste le même du début à la fin :

```text
code source
  ↓
repository Git
  ↓
pull request
  ↓
pipeline CI
  ↓
artefact
  ↓
pipeline CD
  ↓
environnement de test
  ↓
production
  ↓
rollback si nécessaire
```

## Contenu

1. [Le cycle de vie applicatif](cours/01_cycle_de_vie_applicatif.md)
2. [Azure DevOps dans le cycle de vie](cours/02_azure_devops.md)
3. [Git, branches et pull requests](cours/03_git_repos_branches_pr.md)
4. [Premier pipeline YAML](cours/04_premier_pipeline_yaml.md)
5. [Intégration continue](cours/05_integration_continue.md)
6. [Artefacts de build](cours/06_artefacts.md)
7. [Déploiement continu et environnements](cours/07_deploiement_continu_environnements.md)
8. [Déploiement Azure App Service](cours/08_deploiement_azure_app_service.md)
9. [Variables, secrets et Key Vault](cours/09_variables_secrets_keyvault.md)
10. [Approbations, checks et production](cours/10_approbations_checks_production.md)
11. [Deployment slots, Blue/Green et rollback](cours/11_slots_blue_green_rollback.md)
12. [Pipeline complet](cours/12_pipeline_complet.md)
13. [Bonnes pratiques](cours/13_bonnes_pratiques.md)

## Démos

Le dossier `demos/` contient une application de départ et plusieurs fichiers YAML prêts à copier dans Azure DevOps.

- [`demos/app-croissant-start.zip`](demos/app-croissant-start.zip) : application de départ pour les démonstrations.
- [`demos/pipelines/`](demos/pipelines/) : exemples de pipelines CI, CD et production.

## Exercices

Les exercices sont regroupés dans le dossier `exercices/`.
Les corrigés sont dans le dossier `corriges/`.
