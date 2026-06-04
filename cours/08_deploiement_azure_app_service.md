# 8. Déploiement Azure App Service

Azure App Service permet d’héberger une application web sans gérer directement les serveurs.

Pour Croissant API, Azure App Service sert de cible de déploiement.

Le pipeline Azure DevOps construit l’application, produit un artefact, puis déploie cet artefact sur App Service.

## Ressources Azure utilisées

Un déploiement App Service repose généralement sur ces ressources :

| Ressource | Rôle |
|---|---|
| Resource Group | conteneur logique des ressources |
| App Service Plan | capacité d’hébergement |
| App Service | application web |
| Application Settings | configuration de l’application |

Exemple :

```text
Resource Group     : rg-croissant-demo
App Service Plan   : asp-croissant-demo
App Service Dev    : app-croissant-dev
App Service Staging: app-croissant-staging
App Service Prod   : app-croissant-prod
```

## Service Connection

Azure DevOps doit avoir le droit de déployer dans Azure.

Pour cela, on utilise une **Service Connection**.

Elle représente une connexion sécurisée entre Azure DevOps et Azure.

Dans un pipeline, elle est référencée par son nom :

```yaml
azureSubscription: "sc-azure-croissant"
```

La Service Connection doit avoir uniquement les droits nécessaires.

## Déployer avec AzureWebApp

Azure Pipelines fournit la tâche `AzureWebApp@1`.

Exemple :

```yaml
- task: AzureWebApp@1
  displayName: "Déployer sur Azure App Service"
  inputs:
    azureSubscription: "sc-azure-croissant"
    appType: "webAppLinux"
    appName: "app-croissant-dev"
    package: "$(Pipeline.Workspace)/croissant-api"
```

Les champs importants :

| Champ | Sens |
|---|---|
| `azureSubscription` | nom de la Service Connection |
| `appType` | type d’App Service |
| `appName` | nom de l’application Azure |
| `package` | chemin vers l’artefact à déployer |

## Variables de déploiement

On évite d’écrire les noms partout en dur.

On peut utiliser des variables :

```yaml
variables:
  azureServiceConnection: "sc-azure-croissant"
  devAppName: "app-croissant-dev"
```

Puis :

```yaml
- task: AzureWebApp@1
  inputs:
    azureSubscription: "$(azureServiceConnection)"
    appType: "webAppLinux"
    appName: "$(devAppName)"
    package: "$(Pipeline.Workspace)/croissant-api"
```

## Pipeline CI + déploiement Dev

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

variables:
  azureServiceConnection: "sc-azure-croissant"
  devAppName: "app-croissant-dev"

stages:
  - stage: Build
    displayName: "Build"
    jobs:
      - job: BuildJob
        steps:
          - checkout: self

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

  - stage: Deploy_Dev
    displayName: "Déploiement Dev"
    dependsOn: Build
    jobs:
      - deployment: DeployDev
        environment: "croissant-dev"
        strategy:
          runOnce:
            deploy:
              steps:
                - task: DownloadPipelineArtifact@2
                  inputs:
                    artifact: "croissant-api"
                    path: "$(Pipeline.Workspace)/croissant-api"

                - task: AzureWebApp@1
                  displayName: "Déployer sur App Service Dev"
                  inputs:
                    azureSubscription: "$(azureServiceConnection)"
                    appType: "webAppLinux"
                    appName: "$(devAppName)"
                    package: "$(Pipeline.Workspace)/croissant-api"
```

## Vérifier le déploiement

Après le déploiement, on peut vérifier la route `/health`.

```yaml
- script: |
    curl --fail https://$(devAppName).azurewebsites.net/health
  displayName: "Vérifier /health"
```

Cette vérification simple évite de considérer un déploiement comme réussi si l’application ne répond pas.
