# Chapitre 6 — Registry et Azure Container Registry

Une image Docker construite sur un agent Azure Pipelines disparaît à la fin du run si elle n’est pas publiée.

L’agent est temporaire.

```text
run du pipeline
   ↓
agent temporaire
   ↓
image construite localement sur l’agent
   ↓
fin du run
   ↓
agent supprimé
```

Pour réutiliser l’image, il faut la pousser dans un registry.

## Registry

Un registry est un entrepôt d’images Docker.

Exemples :

```text
Docker Hub
GitHub Container Registry
Azure Container Registry
```

Dans Azure, le registry s’appelle **Azure Container Registry**, souvent abrégé **ACR**.

```text
Azure Container Registry
   ↓
croissantregistry.azurecr.io/croissant-api:128
```

## Pourquoi ACR dans ce cours

Comme la cible de déploiement est Azure, ACR est un choix naturel.

```text
Azure Pipelines
   ↓
docker build
   ↓
docker push vers ACR
   ↓
Azure App Service récupère l’image depuis ACR
```

Le registry devient le point de passage entre CI et CD.

```text
CI produit l’image
Registry stocke l’image
CD déploie l’image
```

## Tag d’image

Le tag identifie une version de l’image.

```text
croissant-api:128
croissant-api:main-128
croissant-api:1.0.0
```

Éviter de se baser uniquement sur `latest`.

```text
latest ne dit pas précisément quelle version tourne
```

Préférer un tag traçable :

```text
$(Build.BuildId)
$(Build.SourceBranchName)-$(Build.BuildId)
v1.2.0
```

Exemple :

```yaml
variables:
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
```

## Docker@2

Azure Pipelines propose une tâche Docker.

```yaml
- task: Docker@2
  displayName: "Build and push"
  inputs:
    command: buildAndPush
    repository: $(imageRepository)
    dockerfile: Dockerfile
    containerRegistry: acr-service-connection
    tags: |
      $(imageTag)
```

Cette tâche fait deux choses :

```text
docker build
docker push
```

`containerRegistry` référence une service connection vers le registry.

## Service connection Docker Registry

Le pipeline doit être autorisé à pousser dans ACR.

Dans Azure DevOps :

```text
Project Settings
   ↓
Service connections
   ↓
New service connection
   ↓
Docker Registry
   ↓
Azure Container Registry
```

Nom possible :

```text
sc-acr-croissant
```

Dans le YAML :

```yaml
containerRegistry: sc-acr-croissant
```

## Pipeline build and push

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
  dockerfilePath: Dockerfile

stages:
  - stage: Test
    jobs:
      - job: Tests
        steps:
          - script: npm test

  - stage: Build_And_Push
    dependsOn: Test
    jobs:
      - job: DockerBuildPush
        steps:
          - task: Docker@2
            displayName: "Build and push vers ACR"
            inputs:
              command: buildAndPush
              repository: $(imageRepository)
              dockerfile: $(dockerfilePath)
              containerRegistry: sc-acr-croissant
              tags: |
                $(imageTag)
```

Résultat :

```text
ACR contient croissant-api:<BuildId>
```

Le CD pourra ensuite déployer cette image.
