# Chapitre 8 — CD : déployer l’image Docker

Le CD commence quand une image Docker validée existe dans le registry.

```text
ACR contient croissant-api:128
   ↓
le pipeline déploie cette image
   ↓
App Service lance croissant-api:128
```

## Déployer une image sur App Service

Azure Pipelines propose la tâche `AzureWebAppContainer@1`.

Exemple :

```yaml
- task: AzureWebAppContainer@1
  displayName: "Déployer l'image sur App Service"
  inputs:
    azureSubscription: sc-azure-croissant
    appName: croissant-api-demo
    containers: croissantregistrydemo.azurecr.io/croissant-api:$(Build.BuildId)
```

`azureSubscription` référence une service connection Azure Resource Manager.

`containers` indique l’image à lancer.

## Service connection Azure Resource Manager

Pour déployer dans Azure, Azure Pipelines doit être autorisé à agir sur l’abonnement Azure.

Dans Azure DevOps :

```text
Project Settings
   ↓
Service connections
   ↓
New service connection
   ↓
Azure Resource Manager
```

Nom possible :

```text
sc-azure-croissant
```

Le pipeline utilise cette connexion pour modifier l’App Service.

## Pipeline avec CI + push + déploiement dev

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

variables:
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
  acrLoginServer: croissantregistrydemo.azurecr.io
  devAppName: croissant-api-dev

stages:
  - stage: Test
    jobs:
      - job: Tests
        steps:
          - script: npm test

  - stage: Build_And_Push
    dependsOn: Test
    jobs:
      - job: BuildPush
        steps:
          - task: Docker@2
            inputs:
              command: buildAndPush
              repository: $(imageRepository)
              dockerfile: Dockerfile
              containerRegistry: sc-acr-croissant
              tags: |
                $(imageTag)

  - stage: Deploy_Dev
    dependsOn: Build_And_Push
    jobs:
      - deployment: DeployDev
        environment: croissant-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebAppContainer@1
                  inputs:
                    azureSubscription: sc-azure-croissant
                    appName: $(devAppName)
                    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)
```

Ici, le déploiement dépend du build and push.

```text
Test → Build_And_Push → Deploy_Dev
```

## Deployment job

Le job de déploiement utilise le mot-clé `deployment`.

```yaml
- deployment: DeployDev
  environment: croissant-dev
```

Cela permet à Azure DevOps d’associer le run à un environnement.

Les environnements Azure DevOps servent à :

```text
tracer les déploiements
ajouter des approbations
appliquer des checks
visualiser l’historique
```

## Smoke test après déploiement

Après un déploiement, on vérifie que l’application répond.

```yaml
- script: curl --fail https://croissant-api-dev.azurewebsites.net/health
  displayName: "Vérifier /health"
```

Le smoke test doit rester simple.

```text
l’application répond-elle ?
la route /health est-elle OK ?
la version retournée correspond-elle au tag attendu ?
```

## CD n’est pas forcément production

Déployer en dev ou staging fait déjà partie du CD.

```text
CD = automatiser la livraison vers un environnement
```

La production peut rester protégée par une validation humaine.

```text
déploiement automatique en dev
   ↓
déploiement automatique en staging
   ↓
approbation
   ↓
production
```
