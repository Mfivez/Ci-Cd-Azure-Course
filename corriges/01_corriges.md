# Corrigés

## Exercice 1

Ordre possible :

```text
Commit
  ↓
Pull request
  ↓
Build
  ↓
Tests automatisés
  ↓
Artefact
  ↓
Déploiement staging
  ↓
Déploiement en production
```

## Exercice 2

| Action | CI ou CD |
|---|---|
| lancer les tests unitaires | CI |
| déployer sur App Service | CD |
| publier un artefact | CI, souvent fin de CI |
| faire un smoke test après déploiement | CD |
| installer les dépendances | CI |
| attendre une approbation production | CD |

## Exercice 3

1. local
2. dev
3. staging
4. production

## Exercice 4

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: "20.x"

  - script: npm ci
    displayName: "Installer les dépendances"

  - script: npm test
    displayName: "Lancer les tests"
```

## Exercice 5

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: "20.x"

  - script: npm ci
    displayName: "Installer les dépendances"

  - script: npm test
    displayName: "Lancer les tests"

  - script: |
      mkdir -p $(Build.ArtifactStagingDirectory)/app
      cp package*.json $(Build.ArtifactStagingDirectory)/app/
      cp -r src $(Build.ArtifactStagingDirectory)/app/src
    displayName: "Préparer l’artefact"

  - task: PublishPipelineArtifact@1
    inputs:
      targetPath: "$(Build.ArtifactStagingDirectory)/app"
      artifact: "croissant-api"
      publishLocation: "pipeline"
```

## Exercice 6

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
      - job: DeployDev
        steps:
          - task: DownloadPipelineArtifact@2
            inputs:
              artifact: "croissant-api"
              path: "$(Pipeline.Workspace)/croissant-api"

          - script: echo "Déploiement Dev"
```

## Exercice 7

| Valeur | Variable ou secret |
|---|---|
| nom de l’App Service | variable simple |
| chaîne de connexion SQL | secret |
| nom du Resource Group | variable simple |
| clé API externe | secret |
| nom de l’environnement | variable simple |
| token d’accès | secret |

## Exercice 8

Protections possibles :

```text
approbation manuelle
branch control sur main
exclusive lock
checks de monitoring
permissions limitées
Service Connection protégée
Variable Group protégé
```

## Exercice 9

Avant le swap :

```text
production = v1
staging = v2
```

Après le swap :

```text
production = v2
staging = v1
```

Pour revenir à `v1`, on effectue un swap inverse.

## Exercice 10

- Le stage qui produit l’artefact : `Build`
- Le stage qui déploie en Dev : `Deploy_Dev`
- Le stage qui déploie sur le slot staging : `Deploy_Production`
- Le step qui effectue le swap : `AzureAppServiceManage@0` avec `Action: "Swap Slots"`
- Smoke tests : Dev, Staging, slot staging et Production
