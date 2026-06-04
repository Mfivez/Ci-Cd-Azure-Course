# J1 — Démo guidée — Créer et lire un premier pipeline

## Objectif

Créer ou montrer un pipeline très simple qui s’exécute sur Azure DevOps.

Le but n’est pas encore de builder une vraie application. Le but est de comprendre la mécanique.

## Préparation

Avoir un repository contenant au minimum :

```text
README.md
azure-pipelines.yml
```

## Étape 1 — Montrer le repository

À dire :

> Le pipeline est un fichier dans le repo, comme le code. Il est donc versionné, relu et historisé.

## Étape 2 — Créer le fichier azure-pipelines.yml

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Bonjour depuis Azure Pipelines"
    displayName: "Premier step"
```

## Étape 3 — Expliquer chaque ligne

```yaml
trigger:
  - main
```

Le pipeline démarre quand la branche `main` reçoit un changement.

```yaml
pool:
  vmImage: ubuntu-latest
```

Azure DevOps fournit une machine Linux temporaire.

```yaml
steps:
  - script: echo "Bonjour depuis Azure Pipelines"
```

Le pipeline exécute une commande.

## Étape 4 — Lancer le pipeline

Dans Azure DevOps :

```text
Pipelines → New Pipeline → Azure Repos Git → choisir le repo → Existing Azure Pipelines YAML file
```

Puis lancer le pipeline.

## Étape 5 — Lire les logs

À montrer :

- le run ;
- le job ;
- le step ;
- le log de la commande `echo` ;
- le statut vert ou rouge.

## Étape 6 — Ajouter une erreur volontaire

Modifier :

```yaml
steps:
  - script: exit 1
    displayName: "Erreur volontaire"
```

Relancer.

À dire :

> Un pipeline rouge est utile. Il nous dit que quelque chose ne va pas avant d’aller plus loin.

## Étape 7 — Passer à une structure avec stage/job/step

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
          - script: echo "Build ok"
```

À faire remarquer :

```text
Pipeline
  Stage Build
    Job BuildJob
      Step script
```

## Variante sans environnement Azure

Si Azure DevOps n’est pas disponible :

- montrer le YAML ;
- demander aux participants de repérer trigger, pool, stage, job, step ;
- simuler le résultat au tableau.
