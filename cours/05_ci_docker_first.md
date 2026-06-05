# Chapitre 5 — CI Docker-first : tests, build image et smoke test

La CI Docker-first doit vérifier trois choses.

```text
1. le code passe les tests
2. l’image Docker peut être construite
3. le conteneur démarre et répond
```

Le troisième point est important. Une image peut se construire correctement mais échouer au démarrage.

## Étape 1 — tests applicatifs

```yaml
- script: npm test
  displayName: "Lancer les tests Node.js"
```

Ces tests vérifient le comportement du code.

Exemples :

```text
/health retourne status ok
/version retourne le nom de l’application
/products retourne une liste de produits
```

## Étape 2 — build Docker

```yaml
- script: docker build -t croissant-api:$(Build.BuildId) .
  displayName: "Construire l'image Docker"
```

Le tag utilise l’identifiant du build.

```text
croissant-api:125
croissant-api:126
croissant-api:127
```

Ce tag permet de retrouver précisément quelle image vient de quel run.

## Étape 3 — smoke test du conteneur

Un smoke test est une vérification rapide après démarrage.

```yaml
- script: |
    docker run -d --name croissant-api-test -p 8080:8080 croissant-api:$(Build.BuildId)
    sleep 5
    curl --fail http://localhost:8080/health
    docker rm -f croissant-api-test
  displayName: "Smoke test du conteneur"
```

Cette étape vérifie que :

```text
le conteneur démarre
le port est exposé correctement
l’endpoint /health répond
```

## Pipeline CI complet

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

variables:
  imageName: croissant-api
  imageTag: $(Build.BuildId)

stages:
  - stage: CI
    displayName: "CI Docker-first"
    jobs:
      - job: TestBuildAndSmoke
        displayName: "Tests, image et smoke test"
        steps:
          - checkout: self

          - script: npm test
            displayName: "Lancer les tests"

          - script: docker build -t $(imageName):$(imageTag) .
            displayName: "Construire l'image Docker"

          - script: |
              docker run -d --name croissant-api-test -p 8080:8080 $(imageName):$(imageTag)
              sleep 5
              curl --fail http://localhost:8080/health
              docker rm -f croissant-api-test
            displayName: "Smoke test du conteneur"
```

Ce pipeline ne déploie rien. Il garantit que l’application est testée et conteneurisable.

## CI sur pull request vs CI sur main

Sur pull request, il suffit souvent de tester et construire l’image sans la publier.

```text
pull request
   ↓
npm test
   ↓
docker build
   ↓
smoke test
```

Sur `main`, on peut aller plus loin et publier l’image dans un registry.

```text
merge vers main
   ↓
npm test
   ↓
docker build
   ↓
docker push
```

Cette séparation évite de remplir le registry avec des images de toutes les branches de travail.

## Échec du pipeline

Si une étape échoue, le pipeline s’arrête.

Exemples :

```text
un test échoue
le Dockerfile est invalide
le conteneur ne démarre pas
/health ne répond pas
```

La CI donne alors un feedback rapide. La correction se fait avant de déployer.
