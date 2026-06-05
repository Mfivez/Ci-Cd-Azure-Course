# Chapitre 3 — `azure-pipelines.yml` et Pipeline as Code

Le fichier `azure-pipelines.yml` décrit le pipeline CI/CD.

Il dit à Azure DevOps :

```text
quand lancer le pipeline
sur quelle machine travailler
quelles étapes exécuter
quelles variables utiliser
quels environnements cibler
comment enchaîner build, tests et déploiement
```

Comme ce fichier est stocké dans GitHub avec le code, le pipeline devient versionné.

```text
code applicatif + code du pipeline = même historique Git
```

C’est le principe de **Pipeline as Code**.

## Un pipeline minimal

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Bonjour depuis Azure Pipelines"
```

Ce pipeline :

```text
se déclenche sur main
utilise un agent Ubuntu
exécute une commande shell
```

## Agent

L’agent est la machine qui exécute le pipeline.

```text
Azure Pipelines
   ↓
démarre un agent
   ↓
checkout du code
   ↓
exécution des steps
```

Avec un agent Microsoft-hosted, Azure fournit une machine temporaire.

Exemple :

```yaml
pool:
  vmImage: ubuntu-latest
```

Pour commencer, `ubuntu-latest` suffit largement. L’agent contient déjà beaucoup d’outils courants. Pour Docker, il est adapté aux démonstrations standards de build d’image.

## Steps

Les steps sont les actions concrètes.

```yaml
steps:
  - script: npm test
  - script: docker build -t croissant-api:local .
```

Un step peut être une commande directe ou une tâche Azure DevOps.

Commande directe :

```yaml
- script: docker build -t croissant-api:$(Build.BuildId) .
```

Tâche Azure DevOps :

```yaml
- task: Docker@2
  inputs:
    command: build
    Dockerfile: Dockerfile
```

## Stages, jobs, steps

Un pipeline sérieux est souvent structuré en stages.

```text
Pipeline
   ├── Stage: Test
   │      └── Job
   │            └── Steps
   ├── Stage: Build_Image
   │      └── Job
   │            └── Steps
   └── Stage: Deploy
          └── Job
                └── Steps
```

Exemple :

```yaml
stages:
  - stage: Test
    jobs:
      - job: RunTests
        steps:
          - script: npm test

  - stage: Build_Image
    dependsOn: Test
    jobs:
      - job: DockerBuild
        steps:
          - script: docker build -t croissant-api:$(Build.BuildId) .
```

`dependsOn` impose l’ordre.

```text
Build_Image attend Test
```

## Variables

Les variables évitent de répéter des valeurs.

```yaml
variables:
  imageName: croissant-api
  imageTag: $(Build.BuildId)

steps:
  - script: docker build -t $(imageName):$(imageTag) .
```

Azure Pipelines fournit aussi des variables système.

| Variable | Signification |
|---|---|
| `$(Build.BuildId)` | identifiant unique du run |
| `$(Build.SourceBranchName)` | nom de la branche |
| `$(Build.Repository.Name)` | nom du repository |
| `$(System.DefaultWorkingDirectory)` | dossier de travail |

Pour taguer une image Docker, `$(Build.BuildId)` est pratique.

```text
croissant-api:128
croissant-api:129
croissant-api:130
```

## Pourquoi le YAML est important

Sans fichier YAML, une partie de la logique de livraison vit dans l’interface graphique.

Avec un fichier YAML :

```text
le pipeline est relu en pull request
le pipeline est historisé
le pipeline peut être copié
le pipeline peut être corrigé comme du code
le pipeline suit les branches
```

Un changement de pipeline peut donc passer par la même discipline qu’un changement applicatif.

```text
branche
   ↓
modification YAML
   ↓
pull request
   ↓
review
   ↓
merge
```

## Premier pipeline Docker-first

```yaml
trigger:
  - main

pr:
  - main

pool:
  vmImage: ubuntu-latest

variables:
  imageName: croissant-api
  imageTag: $(Build.BuildId)

steps:
  - script: npm test
    displayName: "Lancer les tests"

  - script: docker build -t $(imageName):$(imageTag) .
    displayName: "Construire l'image Docker"
```

Ce pipeline ne pousse pas encore l’image dans un registry. Il vérifie déjà deux choses essentielles :

```text
les tests passent
l’image Docker peut être construite
```
