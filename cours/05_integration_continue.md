# 5. Intégration continue

L’intégration continue vérifie automatiquement que le code peut être intégré dans la branche principale.

Pour Croissant API, la CI doit répondre à cette question :

> Est-ce que l’application s’installe correctement et est-ce que les tests passent ?

## Étapes d’une CI

Une CI standard suit ce chemin :

```text
checkout du code
  ↓
installation du runtime
  ↓
installation des dépendances
  ↓
lint ou analyse de qualité
  ↓
tests
  ↓
build
  ↓
publication des résultats
```

Toutes les étapes ne sont pas toujours présentes dès le début. Le pipeline peut évoluer avec le projet.

## Checkout

Azure Pipelines récupère automatiquement le repository, mais on peut l’indiquer explicitement :

```yaml
- checkout: self
```

`self` signifie : le repository qui contient le pipeline.

## Installation du runtime

Pour Node.js :

```yaml
- task: NodeTool@0
  displayName: "Installer Node.js"
  inputs:
    versionSpec: "20.x"
```

Pour .NET, on utiliserait une autre tâche, par exemple `UseDotNet@2`.

## Installation des dépendances

Pour un projet Node.js :

```yaml
- script: npm ci
  displayName: "Installer les dépendances"
```

`npm ci` est préférable à `npm install` dans un pipeline, car il installe exactement les versions prévues dans le fichier `package-lock.json`.

## Tests

Les tests automatisés sont le cœur de la CI.

```yaml
- script: npm test
  displayName: "Lancer les tests"
```

Un test échoué doit faire échouer le pipeline.

Si le pipeline échoue, la pull request ne devrait pas être mergée.

## Build

Selon la technologie, le build peut prendre plusieurs formes.

Exemples :

```text
npm run build
dotnet build
mvn package
python -m build
docker build
```

Pour Croissant API, l’application est volontairement simple. Le build peut être remplacé par une étape de préparation du package.

## Validation de pull request

La CI peut s’exécuter sur les pull requests.

```yaml
trigger:
  - main

pr:
  - main
```

Avec cette configuration, le pipeline s’exécute :

```text
quand main change
quand une pull request cible main
```

La validation PR évite d’intégrer du code cassé.

## Pipeline CI complet

```yaml
trigger:
  - main

pr:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: CI
    displayName: "Intégration continue"
    jobs:
      - job: BuildAndTest
        displayName: "Build et tests"
        steps:
          - checkout: self

          - task: NodeTool@0
            displayName: "Installer Node.js"
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: "Installer les dépendances"

          - script: npm test
            displayName: "Lancer les tests"

          - script: npm run build --if-present
            displayName: "Build applicatif"
```

## Ce que garantit la CI

La CI ne prouve pas que l’application est parfaite.

Elle garantit plutôt :

```text
le projet s’installe
les tests connus passent
le build ne casse pas
le feedback est rapide
le code est vérifié de manière répétable
```

La CI est donc une première barrière de qualité.
