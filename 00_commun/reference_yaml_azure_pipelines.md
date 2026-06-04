# Référence rapide YAML Azure Pipelines

## Structure minimale

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Hello pipeline"
```

## Structure avec stages

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "Build"

  - stage: Deploy
    dependsOn: Build
    jobs:
      - job: DeployJob
        steps:
          - script: echo "Deploy"
```

## Trigger sur branche main

```yaml
trigger:
  branches:
    include:
      - main
```

## Trigger PR

```yaml
pr:
  branches:
    include:
      - main
```

## Path filters

```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - src/**
      - tests/**
    exclude:
      - docs/**
      - '*.md'
```

## Variables inline

```yaml
variables:
  nodeVersion: '20.x'
  environmentName: 'dev'
```

Utilisation :

```yaml
- script: echo "Node version = $(nodeVersion)"
```

## Variable group

```yaml
variables:
  - group: croissant-dev
```

## Installer Node.js

```yaml
- task: NodeTool@0
  inputs:
    versionSpec: '20.x'
  displayName: 'Installer Node.js'
```

## Commandes npm

```yaml
- script: npm ci
  displayName: 'Installer les dépendances'

- script: npm test
  displayName: 'Lancer les tests'

- script: npm run build
  displayName: 'Build applicatif'
```

## Publier un artefact pipeline

```yaml
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Build.ArtifactStagingDirectory)'
    artifact: 'drop'
  displayName: 'Publier l artefact'
```

## Télécharger un artefact dans un autre stage

```yaml
- download: current
  artifact: drop
```

## Deployment job vers un environment

```yaml
- deployment: DeployDev
  environment: croissant-dev
  strategy:
    runOnce:
      deploy:
        steps:
          - script: echo "Déploiement dev"
```

## Dépendance entre stages

```yaml
- stage: Deploy_Staging
  dependsOn: Deploy_Dev
```

## Condition simple

```yaml
condition: succeeded()
```

## Exécuter seulement sur main

```yaml
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
```

## Déploiement Azure App Service — exemple générique

```yaml
- task: AzureWebApp@1
  inputs:
    azureSubscription: 'Azure-Dev-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-dev'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## Déploiement vers un slot

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer sur slot staging'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-prod'
    deployToSlotOrASE: true
    resourceGroupName: 'rg-croissant-prod'
    slotName: 'staging'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## Swap App Service slots

```yaml
- task: AzureAppServiceManage@0
  displayName: 'Swap staging vers production'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    Action: 'Swap Slots'
    WebAppName: 'croissant-web-prod'
    ResourceGroupName: 'rg-croissant-prod'
    SourceSlot: 'staging'
    SwapWithProduction: true
```

## Smoke test

```yaml
- script: |
    curl -f https://croissant-web-staging.azurewebsites.net/health
  displayName: 'Smoke test /health'
```

## Points d’attention YAML

- Les espaces comptent.
- Ne pas mélanger tabulations et espaces.
- Un `stage` contient des `jobs`.
- Un `job` contient des `steps`.
- Un `deployment` est un type particulier de job.
- Les secrets ne doivent jamais être écrits en clair.
