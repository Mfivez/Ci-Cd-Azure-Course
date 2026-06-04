# 7. Déploiement continu et environnements

Une fois l’artefact produit, le pipeline peut le déployer.

Le CD commence là où la CI s’arrête.

```text
CI : produire une version fiable
CD : envoyer cette version dans un environnement
```

## Chaîne de promotion

Une application n’est généralement pas envoyée directement en production.

Elle passe par une chaîne de promotion :

```text
Dev → Staging → Production
```

Chaque étape ajoute une validation.

| Environnement | Déploiement | Validation |
|---|---|---|
| Dev | automatique | vérification rapide |
| Staging | automatique ou semi-automatique | tests fonctionnels |
| Production | protégé | approbation et monitoring |

## Stage de déploiement

Un stage de déploiement peut télécharger l’artefact et l’envoyer vers une cible.

Exemple simplifié :

```yaml
- stage: Deploy_Dev
  displayName: "Déploiement Dev"
  dependsOn: Build
  jobs:
    - job: DeployDev
      displayName: "Déployer en Dev"
      steps:
        - task: DownloadPipelineArtifact@2
          inputs:
            artifact: "croissant-api"
            path: "$(Pipeline.Workspace)/croissant-api"

        - script: echo "Déploiement en Dev"
```

`dependsOn` indique que le déploiement dépend du stage précédent.

## Jobs de déploiement

Azure Pipelines propose un type de job spécial : `deployment`.

Il permet de cibler un environnement Azure DevOps.

```yaml
- stage: Deploy_Staging
  displayName: "Déploiement Staging"
  dependsOn: Build
  jobs:
    - deployment: DeployStaging
      displayName: "Déployer en Staging"
      environment: "croissant-staging"
      strategy:
        runOnce:
          deploy:
            steps:
              - script: echo "Déploiement dans l’environnement staging"
```

L’intérêt de `environment` est de lier le pipeline à un environnement Azure DevOps.

Cela permet :

```text
historique des déploiements
approbations
checks
traçabilité
protection de la production
```

## Enchaîner les environnements

```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "Build"

  - stage: Deploy_Dev
    dependsOn: Build
    jobs:
      - deployment: DeployDev
        environment: "croissant-dev"
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploy Dev"

  - stage: Deploy_Staging
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        environment: "croissant-staging"
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploy Staging"
```

Ici, staging attend que dev soit terminé.

## Smoke test

Après un déploiement, on exécute souvent un test très simple appelé **smoke test**.

Il vérifie que l’application répond.

Exemple :

```bash
curl https://croissant-api-staging.azurewebsites.net/health
```

Dans un pipeline :

```yaml
- script: |
    curl --fail https://$(APP_HOSTNAME)/health
  displayName: "Smoke test"
```

Si le smoke test échoue, le pipeline s’arrête.

## Déploiement direct ou promotion

Deux approches existent.

Approche moins fiable :

```text
build dev
build staging
build production
```

Approche plus fiable :

```text
build unique
  ↓
artefact unique
  ↓
déploiement dev
  ↓
déploiement staging
  ↓
déploiement production
```

Le CD doit favoriser la promotion de la même version.
