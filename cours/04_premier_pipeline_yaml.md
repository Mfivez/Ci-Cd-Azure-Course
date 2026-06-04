# 4. Premier pipeline YAML

Un pipeline Azure DevOps peut être défini dans un fichier YAML.

Le YAML décrit les étapes que l’agent Azure DevOps doit exécuter.

Pour Croissant API, le premier pipeline se contente de récupérer le code et d’afficher un message.

## Structure minimale

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Premier pipeline Croissant API"
    displayName: "Afficher un message"
```

Ce fichier peut être nommé :

```text
azure-pipelines.yml
```

## Trigger

Le bloc `trigger` indique quand le pipeline démarre.

```yaml
trigger:
  - main
```

Ici, le pipeline démarre lorsqu’un changement arrive sur `main`.

On peut aussi déclencher sur plusieurs branches :

```yaml
trigger:
  branches:
    include:
      - main
      - release/*
```

## Pool et agent

Le bloc `pool` indique sur quelle machine le pipeline sera exécuté.

```yaml
pool:
  vmImage: ubuntu-latest
```

Ici, Azure DevOps fournit une machine Linux temporaire.

Un agent est donc la machine qui exécute les commandes du pipeline.

Types fréquents :

| Type d’agent | Usage |
|---|---|
| Microsoft-hosted | agent fourni automatiquement par Microsoft |
| Self-hosted | agent installé et maintenu par l’équipe |

Pour démarrer, un agent Microsoft-hosted suffit.

## Steps

Les `steps` sont les actions concrètes du pipeline.

```yaml
steps:
  - script: echo "Hello"
    displayName: "Dire bonjour"
```

Un step peut être :

```text
une commande shell
une commande PowerShell
une tâche Azure DevOps prête à l’emploi
un template réutilisable
```

## Stages, jobs et steps

Un pipeline plus structuré utilise trois niveaux :

```text
stage
  └── job
        └── step
```

| Niveau | Rôle |
|---|---|
| stage | grande phase du pipeline |
| job | unité de travail exécutée sur un agent |
| step | action précise |

Exemple :

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    displayName: "Build"
    jobs:
      - job: BuildJob
        displayName: "Construire l’application"
        steps:
          - script: echo "Build en cours"
            displayName: "Afficher le build"
```

## Pourquoi YAML plutôt que Classic

Un pipeline YAML est versionné avec le code.

Cela apporte plusieurs avantages :

```text
historique Git
review en pull request
reproductibilité
partage entre projets
rollback possible
```

Une modification de pipeline devient une modification de code comme les autres.

## Premier pipeline utile

Pour une application Node.js, un premier pipeline utile peut installer les dépendances et lancer les tests :

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    displayName: "Installer Node.js"
    inputs:
      versionSpec: "20.x"

  - script: npm ci
    displayName: "Installer les dépendances"

  - script: npm test
    displayName: "Lancer les tests"
```

Ce pipeline est une première CI.
