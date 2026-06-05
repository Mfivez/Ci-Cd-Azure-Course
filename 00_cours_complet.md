# Cours complet — CI/CD Docker-first avec Azure DevOps

Le cours suit Croissant API depuis le code GitHub jusqu’au déploiement sur Azure. Les pauses **À pratiquer maintenant** indiquent à quel moment réaliser les exercices.


# Chapitre 1 — Du conteneur local à la livraison automatisée

Une application peut très bien fonctionner sur une machine locale et échouer au moment du déploiement. Les causes sont souvent les mêmes : version différente de Node.js, dépendance oubliée, variable d’environnement absente, commande de démarrage différente ou configuration non documentée.

Docker réduit ce problème en emballant l’application et son environnement d’exécution dans une image.

```text
Code source
   ↓
Dockerfile
   ↓
Image Docker
   ↓
Conteneur
```

L’image Docker devient une unité de livraison. Elle contient ce qu’il faut pour démarrer l’application de façon prévisible.

Dans ce cours, le fil conducteur est une petite API appelée **Croissant API**.

```text
Croissant API
   ├── une route /
   ├── une route /health
   ├── une route /version
   └── une route /products
```

L’application est volontairement simple. Le sujet n’est pas de développer une API complexe, mais de suivre son trajet complet : du code GitHub jusqu’à une application déployée sur Azure.

## Le chemin complet

Le trajet Docker-first est le suivant :

```text
GitHub
   ↓
Azure Pipelines
   ↓
Tests automatisés
   ↓
Build de l’image Docker
   ↓
Push de l’image dans Azure Container Registry
   ↓
Déploiement de l’image sur Azure App Service
   ↓
Validation en staging
   ↓
Bascule en production
```

Cette chaîne contient trois familles d’outils.

| Élément | Rôle |
|---|---|
| GitHub | stocke le code source |
| Azure DevOps / Azure Pipelines | automatise les tests, le build et le déploiement |
| Azure | héberge les ressources réelles : registry, application, configuration, logs |

Azure DevOps ne fait pas tourner l’application finale. Il orchestre le processus. L’application tourne dans Azure.

## CI et CD avec Docker

La CI vérifie que le code est intégrable.

```text
push ou pull request
   ↓
installer / vérifier
   ↓
lancer les tests
   ↓
construire l’image Docker
```

Le CD déploie une version validée.

```text
image Docker validée
   ↓
registry
   ↓
environnement dev ou staging
   ↓
production
```

Avec Docker, l’artefact principal n’est plus un `.zip` ou un dossier `dist/`. L’artefact principal devient l’image Docker.

Exemple :

```text
croissant-api:42
croissant-api:1.0.0
croissant-api:main-20260605
```

Une image Docker versionnée permet de répondre clairement à la question :

> Quelle version exacte tourne dans cet environnement ?

## Le principe “build once, deploy many”

Une erreur fréquente consiste à reconstruire l’application pour chaque environnement.

```text
build image pour dev
build image pour staging
build image pour prod
```

Ce modèle est risqué, car la production ne reçoit pas forcément exactement ce qui a été testé.

On préfère :

```text
une image Docker construite une fois
   ↓
déployée en dev
   ↓
déployée en staging
   ↓
déployée en production
```

Ce qui change entre les environnements n’est pas l’image. C’est la configuration.

Exemple :

| Élément | Dev | Production |
|---|---|---|
| Image Docker | `croissant-api:42` | `croissant-api:42` |
| `ENVIRONMENT_NAME` | `dev` | `production` |
| `LOG_LEVEL` | `debug` | `info` |
| URL publique | dev | prod |

La même image peut donc afficher ou utiliser une configuration différente selon l’environnement.

## Pourquoi garder Docker au centre du cours

Docker donne un support concret pour comprendre la CI/CD.

Sans Docker :

```text
Le pipeline produit quelque chose d’un peu abstrait : package, zip, build, dossier.
```

Avec Docker :

```text
Le pipeline produit une image que l’on peut lancer partout de la même manière.
```

Localement :

```bash
docker run -p 8080:8080 croissant-api:local
```

Dans Azure :

```text
Azure App Service lance cette même image depuis Azure Container Registry.
```

Le lien devient simple :

```text
Dockerfile = recette de construction
Image Docker = version livrable
Registry = entrepôt d’images
App Service = endroit où l’image tourne
Pipeline = automatisation du chemin
```



# Chapitre 2 — GitHub comme source du code, Azure Pipelines comme moteur

Le code de Croissant API vit dans GitHub.

```text
GitHub
   └── croissant-api
        ├── src/
        ├── test/
        ├── Dockerfile
        ├── package.json
        └── azure-pipelines.yml
```

Azure DevOps n’a pas besoin de posséder ce code dans Azure Repos. Azure Pipelines peut être connecté à un repository GitHub.

Cela donne l’architecture suivante :

```text
GitHub contient le code
        ↓
Azure Pipelines récupère le code
        ↓
Azure Pipelines exécute le YAML
        ↓
Azure reçoit l’image ou le déploiement
```

## Ce que signifie “Azure Pipelines lit le repo GitHub”

Quand un pipeline est connecté à GitHub, Azure DevOps a l’autorisation de consulter le repository sélectionné. Lorsqu’un événement se produit, par exemple un push ou une pull request, Azure Pipelines démarre un run.

Le run exécute en gros cette logique :

```text
1. démarrer un agent
2. faire un checkout du repository GitHub
3. lire azure-pipelines.yml
4. exécuter les étapes décrites dans le YAML
```

L’agent exécute les commandes sur une copie du code.

```text
GitHub
   ↓ checkout
Agent Azure Pipelines
   ↓
npm test
   ↓
docker build
   ↓
docker push
```

Le code reste dans GitHub. Azure Pipelines ne remplace pas GitHub. Il se branche dessus.

## GitHub comme source de vérité

Si une équipe utilise déjà GitHub, il est souvent plus simple de le garder comme source principale.

```text
GitHub = code source et pull requests
Azure Pipelines = automatisation CI/CD
Azure = hébergement et services cloud
```

Importer un repo GitHub dans Azure Repos crée une copie. Cette copie ne se synchronise pas automatiquement avec GitHub, sauf si une synchronisation est mise en place séparément.

Dans ce cours, le modèle reste donc :

```text
GitHub d’abord
Azure Pipelines ensuite
Azure comme cible finale
```

## Événements qui déclenchent le pipeline

Un pipeline peut réagir à plusieurs événements.

| Événement | Utilisation |
|---|---|
| push sur `main` | construire et livrer une version |
| pull request vers `main` | valider avant intégration |
| tag Git | créer une version officielle |
| exécution manuelle | relancer ou déployer une version particulière |

Exemple YAML :

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main
```

Ici :

```text
push sur main → pipeline
pull request vers main → pipeline
```

## Pull request et CI

La pull request est un point de contrôle.

```text
branche feature
   ↓
pull request
   ↓
CI automatique
   ↓
review humaine
   ↓
merge vers main
```

Le pipeline exécuté sur pull request ne doit pas forcément déployer. Il doit surtout vérifier.

```text
vérifier les tests
vérifier le Dockerfile
vérifier que l’image peut être construite
```

Le pipeline sur `main`, lui, peut produire et pousser une image versionnée dans un registry.

```text
merge vers main
   ↓
tests
   ↓
docker build
   ↓
docker push
```

## Azure DevOps et GitHub : rôle de l’autorisation

Pour qu’Azure Pipelines puisse accéder à GitHub, une autorisation est nécessaire. Elle se fait lors de la création du pipeline dans Azure DevOps.

Chemin typique :

```text
Azure DevOps
   ↓
Pipelines
   ↓
New pipeline
   ↓
GitHub
   ↓
Sélectionner le repository
   ↓
Choisir ou créer azure-pipelines.yml
```

Une fois la connexion créée, Azure DevOps peut réagir aux changements du repo GitHub.

## Ce qu’il faut retenir

```text
GitHub garde le code.
Azure Pipelines récupère le code au moment du run.
azure-pipelines.yml décrit ce qu’il faut faire.
L’agent exécute les commandes.
Azure reçoit l’image ou le déploiement.
```



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



# Chapitre 4 — Dockerfile et application de démo

Croissant API est une petite application Node.js sans dépendance externe. Elle utilise le module HTTP natif de Node.js.

Structure :

```text
croissant-api/
   ├── src/
   │   ├── app.js
   │   └── server.js
   ├── test/
   │   └── app.test.js
   ├── Dockerfile
   ├── .dockerignore
   ├── docker-compose.yml
   └── package.json
```

## Lancer l’application localement

```bash
npm test
npm start
```

L’application écoute par défaut sur le port `8080`.

```bash
curl http://localhost:8080/health
```

Réponse attendue :

```json
{
  "status": "ok"
}
```

## Construire l’image Docker localement

```bash
docker build -t croissant-api:local .
```

Lancer le conteneur :

```bash
docker run --rm -p 8080:8080 \
  -e ENVIRONMENT_NAME=local \
  -e APP_VERSION=local \
  croissant-api:local
```

Tester :

```bash
curl http://localhost:8080/version
```

Réponse typique :

```json
{
  "name": "croissant-api",
  "version": "local",
  "environment": "local"
}
```

## Dockerfile

Le Dockerfile est la recette de construction de l’image.

```dockerfile
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

COPY package*.json ./
RUN npm install --omit=dev

COPY src ./src

EXPOSE 8080

CMD ["node", "src/server.js"]
```

Lecture ligne par ligne :

| Ligne | Rôle |
|---|---|
| `FROM node:20-alpine` | image de base avec Node.js |
| `WORKDIR /app` | dossier de travail dans l’image |
| `ENV PORT=8080` | port par défaut de l’application |
| `COPY package*.json ./` | copie des métadonnées npm |
| `RUN npm install --omit=dev` | installe les dépendances de production |
| `COPY src ./src` | copie le code applicatif |
| `EXPOSE 8080` | documente le port exposé |
| `CMD ...` | commande lancée au démarrage du conteneur |

## `.dockerignore`

Le fichier `.dockerignore` évite d’envoyer des fichiers inutiles au build Docker.

```text
node_modules
.git
.azure
coverage
*.log
.env
```

Cela accélère le build et évite d’inclure des fichiers sensibles ou inutiles dans l’image.

## Docker Compose

Pour lancer la démo plus facilement :

```yaml
services:
  api:
    build: .
    image: croissant-api:local
    ports:
      - "8080:8080"
    environment:
      ENVIRONMENT_NAME: local
      APP_VERSION: docker-compose
      LOG_LEVEL: debug
```

Commande :

```bash
docker compose up --build
```

## Ce que le pipeline devra reproduire

Localement, on fait :

```bash
npm test
docker build -t croissant-api:local .
docker run -p 8080:8080 croissant-api:local
```

Dans Azure Pipelines, on va automatiser la même logique :

```text
checkout GitHub
   ↓
npm test
   ↓
docker build
   ↓
smoke test du conteneur
```

Le pipeline ne fait donc pas de magie. Il automatise ce qui peut déjà être fait localement.
---

## À pratiquer maintenant — Exercice 1 : lancer Croissant API avec Docker

Avant de continuer, ouvrez l’application de départ et réalisez l’exercice :

- Application : `demos/croissant-api-start/`
- Énoncé : `exercices/01_docker_local.md`
- Corrigé : `corriges/01_docker_local_corrige.md`

À la fin de la pratique, vous devez avoir vérifié que :

```text
npm test passe
l’image croissant-api:local est construite
le conteneur démarre sur le port 8080
/health répond correctement
/version affiche les variables transmises au conteneur
```

Reprenez au chapitre 5 lorsque l’application fonctionne dans un conteneur local.



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
---

## À pratiquer maintenant — Exercice 2 : écrire une CI Docker-first

Avant de passer au registry, réalisez l’exercice :

- Énoncé : `exercices/02_pipeline_ci_docker.md`
- Corrigé : `corriges/02_pipeline_ci_docker_corrige.md`
- Pipeline de référence : `demos/pipelines/01-ci-tests-docker-build.yml`

À la fin, votre pipeline doit être capable de :

```text
récupérer le code
installer les dépendances
lancer les tests
construire une image Docker taguée avec le Build ID
```

Reprenez au chapitre 6 lorsque la CI produit une image Docker localement sur l’agent.



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
---

## À pratiquer maintenant — Exercice 3 : comprendre les tags et le registry

Avant de parler de déploiement, réalisez l’exercice :

- Énoncé : `exercices/03_tags_et_acr.md`
- Corrigé : `corriges/03_tags_et_acr_corrige.md`
- Pipeline de référence : `demos/pipelines/02-build-and-push-acr.yml`

À la fin, vous devez savoir expliquer :

```text
pourquoi une image doit être taguée
pourquoi latest ne suffit pas pour tracer une version
à quoi sert Azure Container Registry
ce que représente une Service Connection vers ACR
```

Variante sans Azure payant : ne créez pas d’ACR. Lisez le pipeline, identifiez la partie `buildAndPush`, puis expliquez ce qui serait exécuté si un registry était disponible.

Reprenez au chapitre 7 lorsque le rôle du registry est clair.



# Chapitre 7 — Azure comme cible de déploiement

Jusqu’ici, le pipeline a produit une image Docker et l’a poussée dans un registry.

```text
GitHub
   ↓
Azure Pipelines
   ↓
Image Docker
   ↓
Azure Container Registry
```

Il manque encore une pièce : l’endroit où l’application tourne.

Dans ce cours, la cible principale est **Azure App Service for Containers**.

```text
Azure Container Registry
   ↓
Azure App Service
   ↓
URL publique
```

## Azure DevOps vs Azure

Il faut garder la distinction claire.

| Élément | Rôle |
|---|---|
| Azure DevOps | automatise la chaîne CI/CD |
| Azure | héberge les ressources qui exécutent l’application |

Azure DevOps orchestre.

Azure héberge.

## Resource Group

Un Resource Group est un conteneur logique de ressources Azure.

Exemple :

```text
rg-croissant-demo
```

Il peut contenir :

```text
Azure Container Registry
App Service Plan
App Service
Deployment Slot
Key Vault
Application Insights
```

Supprimer le Resource Group supprime généralement les ressources qu’il contient. C’est pratique pour nettoyer une démo.

## Azure Container Registry

ACR stocke les images.

```text
croissantregistry.azurecr.io/croissant-api:128
```

C’est une ressource Azure.

## App Service Plan

App Service Plan représente la capacité d’hébergement.

```text
App Service Plan
   ↓
CPU / mémoire / région / niveau de prix
```

L’App Service tourne dans un App Service Plan.

## Azure App Service for Containers

App Service for Containers exécute une image Docker.

```text
Image Docker dans ACR
   ↓
App Service récupère l’image
   ↓
Conteneur démarré
   ↓
Application disponible via une URL
```

Exemple d’URL :

```text
https://croissant-api-demo.azurewebsites.net
```

## Configuration du port

Croissant API écoute sur le port `8080`.

Dans App Service, on configure généralement :

```text
WEBSITES_PORT=8080
```

Cette variable indique à App Service quel port le conteneur expose.

## Application Settings

Les Application Settings sont des variables d’environnement injectées dans l’application.

Exemples :

```text
ENVIRONMENT_NAME=dev
APP_VERSION=128
LOG_LEVEL=info
WEBSITES_PORT=8080
```

Dans le code, l’application lit ces variables.

```js
process.env.ENVIRONMENT_NAME
process.env.APP_VERSION
```

Cela permet d’utiliser la même image avec une configuration différente.

```text
croissant-api:128 + ENVIRONMENT_NAME=dev
croissant-api:128 + ENVIRONMENT_NAME=staging
croissant-api:128 + ENVIRONMENT_NAME=production
```

## Création des ressources avec Azure CLI

Exemple simplifié :

```bash
az group create \
  --name rg-croissant-demo \
  --location westeurope

az acr create \
  --resource-group rg-croissant-demo \
  --name croissantregistrydemo \
  --sku Basic

az appservice plan create \
  --resource-group rg-croissant-demo \
  --name plan-croissant-demo \
  --is-linux \
  --sku B1

az webapp create \
  --resource-group rg-croissant-demo \
  --plan plan-croissant-demo \
  --name croissant-api-demo \
  --deployment-container-image-name croissantregistrydemo.azurecr.io/croissant-api:1
```

Ces commandes créent le terrain de déploiement. Dans la suite, le pipeline mettra à jour l’image utilisée par l’App Service.

## Le flux Azure complet

```text
Azure Container Registry
   stocke l’image

Azure App Service
   lance l’image

Application Settings
   configurent le conteneur

Log Stream
   permet de lire les logs au démarrage
```



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
---

## À pratiquer maintenant — Exercice 4 : déployer une image sur App Service

Avant d’ajouter les environnements, réalisez l’exercice :

- Énoncé : `exercices/04_cd_app_service.md`
- Corrigé : `corriges/04_cd_app_service_corrige.md`
- Pipeline de référence : `demos/pipelines/03-deploy-app-service-container.yml`

À la fin, vous devez savoir relier ces éléments :

```text
image Docker dans ACR
App Service for Containers
commande az webapp config container set
Service Connection Azure
```

Variante sans Azure payant : ne lancez pas la commande Azure CLI. Complétez le YAML et expliquez quelle ressource Azure serait modifiée.

Reprenez au chapitre 9 lorsque le lien entre l’image Docker et App Service est compris.



# Chapitre 9 — Environnements et configuration

Une application n’est pas déployée directement en production sans étape intermédiaire.

On utilise plusieurs environnements.

```text
dev → staging → production
```

Avec Docker, l’objectif est de garder la même image et de changer uniquement la configuration.

```text
même image Docker
   ↓
configuration dev
   ↓
configuration staging
   ↓
configuration production
```

## Environnement Azure DevOps vs environnement Azure

Le mot environnement peut désigner deux choses.

| Élément | Signification |
|---|---|
| Environnement Azure DevOps | objet de pipeline pour approvals, checks, historique |
| Environnement Azure | ressources réelles : App Service, settings, logs, slots |

Exemple :

```text
Azure DevOps environment: croissant-staging
Azure resource: App Service croissant-api-prod slot staging
```

Les deux sont liés mais ne sont pas la même chose.

## Configurer une application sans changer l’image

Croissant API lit ses valeurs depuis les variables d’environnement.

```text
ENVIRONMENT_NAME
APP_VERSION
LOG_LEVEL
```

Dans App Service, ces valeurs se configurent dans Application Settings.

Exemple dev :

```text
ENVIRONMENT_NAME=dev
APP_VERSION=128
LOG_LEVEL=debug
WEBSITES_PORT=8080
```

Exemple production :

```text
ENVIRONMENT_NAME=production
APP_VERSION=128
LOG_LEVEL=info
WEBSITES_PORT=8080
```

Le tag de l’image est le même :

```text
croissant-api:128
```

## Mettre à jour les settings avec Azure CLI

```bash
az webapp config appsettings set \
  --resource-group rg-croissant-demo \
  --name croissant-api-dev \
  --settings \
    ENVIRONMENT_NAME=dev \
    LOG_LEVEL=debug \
    WEBSITES_PORT=8080
```

Pour production :

```bash
az webapp config appsettings set \
  --resource-group rg-croissant-demo \
  --name croissant-api-prod \
  --settings \
    ENVIRONMENT_NAME=production \
    LOG_LEVEL=info \
    WEBSITES_PORT=8080
```

## Variables YAML

Une variable YAML convient pour une valeur non sensible.

```yaml
variables:
  imageRepository: croissant-api
  acrLoginServer: croissantregistrydemo.azurecr.io
```

Ne pas mettre de secret dans le YAML.

Mauvais exemple :

```yaml
variables:
  databasePassword: "SuperSecret123"
```

## Variable groups

Un Variable Group permet de stocker des variables partagées entre pipelines.

Exemple :

```text
vg-croissant-dev
   ENVIRONMENT_NAME=dev
   LOG_LEVEL=debug
   APP_SERVICE_NAME=croissant-api-dev

vg-croissant-prod
   ENVIRONMENT_NAME=production
   LOG_LEVEL=info
   APP_SERVICE_NAME=croissant-api-prod
```

Dans le YAML :

```yaml
variables:
  - group: vg-croissant-dev
```

Les Variable Groups sont utiles quand plusieurs pipelines utilisent les mêmes valeurs.

## Séparation code / configuration

Le code reste identique.

```text
src/app.js
Dockerfile
image Docker
```

La configuration dépend de l’environnement.

```text
ENVIRONMENT_NAME
LOG_LEVEL
URL de base de données
clé API
```

Cette séparation rend le déploiement plus fiable.

```text
On ne reconstruit pas pour changer d’environnement.
On configure l’environnement cible.
```



# Chapitre 10 — Secrets, service connections et Key Vault

Un pipeline CD a besoin d’accéder à des ressources externes.

Exemples :

```text
pousser une image dans ACR
déployer sur App Service
lire des secrets applicatifs
modifier des settings Azure
```

Ces actions nécessitent des droits. Ces droits ne doivent pas être codés en dur dans le repository.

## Ce qu’il ne faut jamais committer

```text
mot de passe
clé API
token
connection string
fichier .env réel
clé privée
publish profile
PAT
```

Le repository doit contenir au maximum des exemples.

```text
.env.example
```

Pas :

```text
.env
```

## Service connection

Une service connection est une identité utilisée par Azure Pipelines pour accéder à un service.

Exemples :

| Service connection | Sert à |
|---|---|
| Docker Registry / ACR | pousser une image Docker |
| Azure Resource Manager | déployer dans Azure |
| GitHub | accéder à un repo GitHub |

Dans le YAML, on référence le nom de la service connection.

```yaml
containerRegistry: sc-acr-croissant
```

```yaml
azureSubscription: sc-azure-croissant
```

Le secret n’apparaît pas dans le YAML. Le YAML ne contient que le nom logique de la connexion.

## Principe du moindre privilège

La service connection ne doit avoir que les droits nécessaires.

Exemples :

```text
pousser dans ACR, pas administrer tout l’abonnement
déployer sur un Resource Group, pas gérer toutes les ressources Azure
lire des secrets précis, pas tout Key Vault
```

Plus les droits sont limités, plus l’impact d’une erreur est réduit.

## Variables secrètes

Dans Azure Pipelines, une variable peut être marquée comme secrète.

```text
Pipelines → Library → Variable Groups
```

Une variable secrète est masquée dans les logs.

```text
***
```

Mais il faut quand même éviter de l’afficher volontairement.

## Azure Key Vault

Azure Key Vault est le coffre-fort Azure pour les secrets.

On peut y stocker :

```text
mots de passe
connection strings
certificats
clés API
```

Un pipeline peut récupérer des secrets depuis Key Vault, ou un App Service peut lire ses secrets via des références Key Vault.

## Variable Group lié à Key Vault

Un Variable Group peut être lié à Key Vault.

```text
Azure Key Vault
   ↓
Variable Group Azure Pipelines
   ↓
Pipeline
```

Cela évite de copier manuellement les secrets dans Azure DevOps.

## Différence entre configuration et secret

| Valeur | Type | Où la mettre |
|---|---|---|
| nom de l’application | configuration | YAML ou Variable Group |
| nom du Resource Group | configuration | YAML ou Variable Group |
| `LOG_LEVEL=info` | configuration | App Settings |
| mot de passe DB | secret | Key Vault |
| clé API externe | secret | Key Vault |
| token de déploiement | secret | Service connection |

## Exemple de variable group

```yaml
variables:
  - group: vg-croissant-dev
```

Puis dans le pipeline :

```yaml
- script: echo "Déploiement vers $(APP_SERVICE_NAME)"
```

Si `APP_SERVICE_NAME` est non sensible, c’est correct.

Si `DATABASE_PASSWORD` est secret, ne jamais faire :

```yaml
- script: echo "$(DATABASE_PASSWORD)"
```

## Secrets et Docker

Ne pas injecter un secret dans l’image au moment du build.

Mauvais modèle :

```dockerfile
ENV DATABASE_PASSWORD=SuperSecret123
```

Bon modèle :

```text
l’image est générique
le secret est injecté au runtime par l’environnement
```

```text
Docker image
   ↓
App Service Application Settings / Key Vault
   ↓
conteneur démarré avec les secrets nécessaires
```

Une image Docker ne doit pas contenir de secret réel.
---

## À pratiquer maintenant — Exercice 5 : séparer configuration et secrets

Avant de passer aux approbations, réalisez l’exercice :

- Énoncé : `exercices/05_configuration_et_secrets.md`
- Corrigé : `corriges/05_configuration_et_secrets_corrige.md`

À la fin, vous devez savoir classer chaque valeur dans la bonne catégorie :

```text
variable non sensible dans le YAML
variable partagée dans un Variable Group
secret masqué dans Azure DevOps
secret applicatif dans Azure Key Vault
```

Reprenez au chapitre 11 lorsque la différence entre configuration et secret est claire.



# Chapitre 11 — Azure Artifacts vs Azure Container Registry

Azure Artifacts et Azure Container Registry sont deux services de stockage, mais ils ne stockent pas le même type de choses.

## Azure Container Registry

Azure Container Registry stocke des images Docker.

Exemples :

```text
croissant-api:128
frontend-web:20260605.1
worker-import:1.4.0
```

Utilisation :

```text
docker build
   ↓
docker push
   ↓
ACR
   ↓
Azure App Service / Container Apps / AKS
```

ACR est le bon choix pour les conteneurs.

## Azure Artifacts

Azure Artifacts stocke des packages applicatifs.

Exemples :

```text
npm
NuGet
Maven
Python
Cargo
Universal Packages
```

Utilisation :

```text
librairie interne
CLI interne
SDK partagé
composant commun
```

Exemple npm :

```text
@company/croissant-cli
@company/ui-components
```

Exemple NuGet :

```text
Company.Croissant.Security
Company.Croissant.Logging
```

## Différence simple

| Besoin | Service |
|---|---|
| stocker une image Docker | Azure Container Registry |
| stocker une librairie npm privée | Azure Artifacts |
| stocker un package NuGet privé | Azure Artifacts |
| déployer une image sur App Service | Azure Container Registry |
| partager une CLI interne | Azure Artifacts |
| centraliser des dépendances publiques npm/NuGet | Azure Artifacts avec upstream sources |

## Packages publics et upstream sources

Azure Artifacts peut aussi servir d’intermédiaire vers des registres publics.

Exemple Angular :

```text
Projet Angular
   ↓
Azure Artifacts feed
   ↓
npmjs.com
```

Avec des upstream sources, un feed Azure Artifacts peut récupérer des packages publics et les conserver dans le feed.

Intérêts :

```text
centraliser les dépendances
contrôler les sources autorisées
mettre en cache certains packages
réduire la dépendance directe aux registres publics
avoir un point de configuration unique pour l’équipe
```

## Exemple avec une CLI interne

Une équipe crée une CLI :

```text
croissant-cli
```

Si cette CLI est distribuée comme package npm :

```bash
npm install -g @company/croissant-cli
```

Azure Artifacts est adapté.

Si cette CLI est distribuée comme image Docker :

```bash
docker run company/croissant-cli:1.0.0
```

Un registry d’images est adapté.

## Dans le fil rouge Docker-first

Pour Croissant API :

```text
l’artefact de livraison = image Docker
le stockage = Azure Container Registry
```

Azure Artifacts peut être présenté comme un service complémentaire pour les packages, mais il n’est pas le registry principal de l’image Docker.



# Chapitre 12 — Approbations, checks et production

Un pipeline peut déployer automatiquement en dev. Pour la production, on ajoute souvent un contrôle humain ou automatique.

```text
dev : automatique
staging : automatique ou semi-automatique
production : protégée
```

Azure DevOps permet de protéger un environnement avec des approvals et checks.

## Environments dans Azure DevOps

Un environnement Azure DevOps sert à tracer et contrôler les déploiements.

Exemples :

```text
croissant-dev
croissant-staging
croissant-production
```

Dans le YAML :

```yaml
- deployment: DeployProduction
  environment: croissant-production
```

Cet environnement peut avoir des règles.

## Approbation manuelle

Une approbation manuelle bloque le pipeline jusqu’à validation.

```text
Deploy_Production démarre
   ↓
Azure DevOps demande une approbation
   ↓
un approver valide
   ↓
le déploiement continue
```

Cela crée une trace :

```text
qui a approuvé
quand
pour quel run
vers quel environnement
```

## Branch control

Un check de branche peut interdire la production depuis une branche autre que `main`.

```text
main → autorisé
feature/test → bloqué
```

Ce check évite les déploiements accidentels.

## Exclusive lock

Un exclusive lock évite deux déploiements simultanés sur le même environnement.

```text
pipeline A déploie staging
pipeline B attend
```

C’est utile pour éviter les collisions.

## Deployment job complet

```yaml
- stage: Deploy_Production
  dependsOn: Deploy_Staging
  jobs:
    - deployment: DeployProduction
      environment: croissant-production
      strategy:
        runOnce:
          deploy:
            steps:
              - task: AzureWebAppContainer@1
                inputs:
                  azureSubscription: sc-azure-croissant
                  appName: croissant-api-prod
                  containers: $(acrLoginServer)/$(imageRepository):$(imageTag)
```

Le YAML demande le déploiement.

L’environnement décide si le déploiement doit attendre une approbation.

## Approvals dans le portail

Configuration typique :

```text
Azure DevOps
   ↓
Pipelines
   ↓
Environments
   ↓
croissant-production
   ↓
Approvals and checks
```

Checks possibles :

```text
approbation manuelle
branch control
business hours
exclusive lock
requête REST externe
Azure Monitor alerts
```

## Production ne veut pas dire tout automatique

Continuous Deployment signifie que tout peut aller automatiquement jusqu’en production.

Continuous Delivery signifie qu’une version est prête, mais une validation peut rester nécessaire.

Dans beaucoup d’équipes :

```text
CI automatique
CD dev automatique
CD staging automatique
CD production avec approbation
```

Ce modèle est déjà très professionnel.



# Chapitre 13 — Deployment slots, Blue/Green et rollback

Déployer directement en production est risqué.

```text
nouvelle image
   ↓
production directe
   ↓
si problème, les utilisateurs sont impactés
```

Les deployment slots permettent de déployer à côté de la production.

```text
App Service
   ├── slot production
   └── slot staging
```

## Déploiement vers staging

Le pipeline déploie d’abord la nouvelle image sur le slot staging.

```text
production : ancienne version
staging    : nouvelle version
```

On teste ensuite staging.

```bash
curl --fail https://croissant-api-prod-staging.azurewebsites.net/health
```

Si tout est correct, on fait un swap.

## Swap

Le swap échange staging et production.

Avant :

```text
production : v1
staging    : v2
```

Après :

```text
production : v2
staging    : v1
```

Ce modèle se rapproche d’un déploiement Blue/Green.

```text
Blue  = version actuelle
Green = nouvelle version
```

On prépare Green, on teste Green, puis on bascule le trafic.

## Déployer vers un slot avec AzureWebAppContainer@1

```yaml
- task: AzureWebAppContainer@1
  displayName: "Déployer sur staging"
  inputs:
    azureSubscription: sc-azure-croissant
    appName: croissant-api-prod
    deployToSlotOrASE: true
    resourceGroupName: rg-croissant-demo
    slotName: staging
    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)
```

## Swap avec AzureAppServiceManage@0

```yaml
- task: AzureAppServiceManage@0
  displayName: "Swap staging vers production"
  inputs:
    azureSubscription: sc-azure-croissant
    Action: "Swap Slots"
    WebAppName: croissant-api-prod
    ResourceGroupName: rg-croissant-demo
    SourceSlot: staging
    SwapWithProduction: true
```

## Rollback

Le rollback consiste à revenir rapidement à la version précédente.

Avec les slots, après un swap réussi :

```text
production : v2
staging    : v1
```

Si v2 pose problème, on peut refaire le swap inverse.

```text
production : v1
staging    : v2
```

C’est beaucoup plus simple que de reconstruire une ancienne version dans l’urgence.

## Slot settings

Certaines configurations doivent rester attachées au slot.

Exemples :

```text
ENVIRONMENT_NAME
connection string staging
URL de service de test
```

Dans Azure App Service, on peut marquer certains settings comme slot-specific.

Cela évite que la configuration staging parte en production lors du swap.

## Pipeline staging puis production

```text
Build image
   ↓
Push ACR
   ↓
Deploy slot staging
   ↓
Smoke test staging
   ↓
Approval production
   ↓
Swap staging → production
```

Ce modèle réduit fortement le risque.

La nouvelle image est testée dans un environnement réel avant d’être exposée aux utilisateurs.
---

## À pratiquer maintenant — Exercice 6 : staging, swap et rollback

Avant d’aborder les notions as code, réalisez l’exercice :

- Énoncé : `exercices/06_slots_rollback.md`
- Corrigé : `corriges/06_slots_rollback_corrige.md`
- Pipeline de référence : `demos/pipelines/05-slot-staging-swap.yml`

À la fin, vous devez être capable de dessiner ce cycle :

```text
production = ancienne version
staging = nouvelle version
validation staging
swap staging → production
rollback par swap inverse si problème
```

Variante sans Azure payant : travaillez sur le schéma et les commandes CLI sans les exécuter.

Reprenez au chapitre 14 lorsque le mécanisme de swap et de rollback est clair.



# Chapitre 14 — Infrastructure as Code, Configuration as Code, Pipeline as Code

Les termes se ressemblent, mais ils ne désignent pas la même chose.

```text
Pipeline as Code
Configuration as Code
Infrastructure as Code
```

Ils ont un point commun : écrire dans des fichiers ce qui était souvent fait à la main dans une interface.

## Pipeline as Code

Pipeline as Code signifie que le pipeline est décrit dans un fichier.

Exemple :

```text
azure-pipelines.yml
```

Il décrit :

```text
triggers
stages
jobs
steps
tests
build Docker
push ACR
deploy App Service
```

Le pipeline est versionné avec le code.

```text
modification du pipeline
   ↓
pull request
   ↓
review
   ↓
historique Git
```

## Configuration as Code

Configuration as Code signifie que la configuration non sensible est décrite dans des fichiers ou dans des objets gérés.

Exemples :

```text
docker-compose.yml
variables YAML
Variable Groups
fichiers de templates
valeurs d’environnement documentées
```

Exemple :

```yaml
variables:
  imageRepository: croissant-api
  acrLoginServer: croissantregistrydemo.azurecr.io
```

Ou :

```yaml
services:
  api:
    environment:
      ENVIRONMENT_NAME: local
      LOG_LEVEL: debug
```

Configuration as Code ne veut pas dire committer les secrets.

```text
config non sensible : oui
secret réel : non
```

## Infrastructure as Code

Infrastructure as Code signifie que les ressources cloud sont décrites dans des fichiers.

Exemples de ressources :

```text
Resource Group
Azure Container Registry
App Service Plan
App Service
Deployment Slot
Key Vault
Application Insights
```

Outils possibles :

```text
Bicep
Terraform
ARM templates
Pulumi
```

Avec Bicep, on décrit l’état souhaité des ressources Azure.

Exemple simplifié :

```bicep
resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'plan-croissant-demo'
  location: resourceGroup().location
  sku: {
    name: 'B1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}
```

Le principe :

```text
au lieu de cliquer dans Azure Portal
on écrit l’infrastructure dans un fichier
```

## Comparaison

| Terme | Décrit quoi ? | Exemple |
|---|---|---|
| Pipeline as Code | la chaîne CI/CD | `azure-pipelines.yml` |
| Configuration as Code | les paramètres et valeurs non sensibles | `docker-compose.yml`, variables YAML |
| Infrastructure as Code | les ressources cloud | `main.bicep`, `main.tf` |

## Dans le fil rouge Croissant API

```text
Infrastructure as Code
   crée ACR, App Service, slots

Configuration as Code
   définit ENVIRONMENT_NAME, LOG_LEVEL, ports

Pipeline as Code
   automatise tests, docker build, docker push, déploiement
```

Les trois couches se complètent.

```text
Infrastructure = où l’application peut tourner
Configuration = comment elle se comporte
Pipeline = comment elle arrive jusque-là
```
---

## À pratiquer maintenant — Exercice 7 : distinguer IaC, CaC et Pipeline as Code

Avant de lire le pipeline complet, réalisez l’exercice :

- Énoncé : `exercices/07_iac_cac_pipeline_as_code.md`
- Corrigé : `corriges/07_iac_cac_pipeline_as_code_corrige.md`
- Exemple IaC : `demos/infra/main.bicep`

À la fin, vous devez savoir classer un fichier comme :

```text
Infrastructure as Code
Configuration as Code
Pipeline as Code
secret à ne pas versionner
```

Reprenez au chapitre 15 lorsque les trois notions sont bien séparées.



# Chapitre 15 — Pipeline complet end-to-end

Le pipeline complet Docker-first suit tout le trajet.

```text
GitHub
   ↓
Tests
   ↓
Build image Docker
   ↓
Push vers Azure Container Registry
   ↓
Deploy vers dev
   ↓
Deploy vers staging slot
   ↓
Smoke test staging
   ↓
Approval production
   ↓
Swap staging vers production
```

## Version complète

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
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
  acrLoginServer: croissantregistrydemo.azurecr.io
  resourceGroupName: rg-croissant-demo
  devAppName: croissant-api-dev
  prodAppName: croissant-api-prod
  stagingSlotName: staging

stages:
  - stage: Test
    displayName: "Tests"
    jobs:
      - job: TestNode
        steps:
          - checkout: self
          - script: npm test
            displayName: "Tests Node.js"

  - stage: Build_Image
    displayName: "Build image Docker"
    dependsOn: Test
    jobs:
      - job: DockerBuild
        steps:
          - checkout: self
          - script: docker build -t $(imageRepository):$(imageTag) .
            displayName: "Docker build"
          - script: |
              docker run -d --name croissant-api-test -p 8080:8080 $(imageRepository):$(imageTag)
              sleep 5
              curl --fail http://localhost:8080/health
              docker rm -f croissant-api-test
            displayName: "Smoke test local du conteneur"

  - stage: Push_ACR
    displayName: "Push vers Azure Container Registry"
    dependsOn: Build_Image
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: DockerPush
        steps:
          - checkout: self
          - task: Docker@2
            displayName: "Build and push ACR"
            inputs:
              command: buildAndPush
              repository: $(imageRepository)
              dockerfile: Dockerfile
              containerRegistry: sc-acr-croissant
              tags: |
                $(imageTag)

  - stage: Deploy_Dev
    displayName: "Déploiement dev"
    dependsOn: Push_ACR
    jobs:
      - deployment: DeployDev
        environment: croissant-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebAppContainer@1
                  displayName: "Déployer dev"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    appName: $(devAppName)
                    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)

                - script: curl --fail https://$(devAppName).azurewebsites.net/health
                  displayName: "Smoke test dev"

  - stage: Deploy_Staging
    displayName: "Déploiement staging slot"
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        environment: croissant-staging
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebAppContainer@1
                  displayName: "Déployer sur slot staging"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    appName: $(prodAppName)
                    deployToSlotOrASE: true
                    resourceGroupName: $(resourceGroupName)
                    slotName: $(stagingSlotName)
                    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)

                - script: curl --fail https://$(prodAppName)-$(stagingSlotName).azurewebsites.net/health
                  displayName: "Smoke test staging"

  - stage: Promote_Production
    displayName: "Promotion production"
    dependsOn: Deploy_Staging
    jobs:
      - deployment: SwapProduction
        environment: croissant-production
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureAppServiceManage@0
                  displayName: "Swap staging vers production"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    Action: "Swap Slots"
                    WebAppName: $(prodAppName)
                    ResourceGroupName: $(resourceGroupName)
                    SourceSlot: $(stagingSlotName)
                    SwapWithProduction: true

                - script: curl --fail https://$(prodAppName).azurewebsites.net/health
                  displayName: "Smoke test production"
```

## Lecture du pipeline

```text
Test
   vérifie le code

Build_Image
   construit l’image et vérifie qu’elle démarre

Push_ACR
   publie l’image dans Azure Container Registry

Deploy_Dev
   déploie automatiquement en dev

Deploy_Staging
   déploie la nouvelle image sur le slot staging

Promote_Production
   swap staging vers production après protection de l’environnement
```

## Condition sur main

```yaml
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
```

Cette condition évite de pousser une image dans ACR depuis une pull request ou une branche de travail.

```text
pull request → tests + docker build
main → tests + docker build + push + déploiement
```

## Protection de la production

La protection n’est pas écrite directement dans ce YAML. Elle se configure sur l’environnement Azure DevOps `croissant-production`.

Exemples :

```text
approbation manuelle
branch control main only
exclusive lock
```

Le YAML demande le déploiement. L’environnement contrôle le passage.

## Rollback

Si la production pose problème après le swap :

```text
production : nouvelle version
staging    : ancienne version
```

Rollback rapide :

```text
refaire un swap staging → production
```

Ou déployer explicitement un ancien tag :

```text
croissant-api:127
```

Le fait de taguer les images rend ce rollback possible.

## Chaîne finale

```text
GitHub = source du code
Azure Pipelines = automatisation
Docker = format de livraison
ACR = stockage des images
App Service = exécution
Deployment slots = réduction du risque
Approvals = contrôle production
Key Vault = secrets
Bicep = infrastructure reproductible
```
---

## À pratiquer maintenant — Exercice 8 : lire le pipeline complet end-to-end

Terminez par l’exercice de synthèse :

- Énoncé : `exercices/08_pipeline_end_to_end.md`
- Corrigé : `corriges/08_pipeline_end_to_end_corrige.md`
- Pipeline complet : `demos/pipelines/04-full-docker-first.yml`

À la fin, vous devez pouvoir expliquer oralement le chemin complet :

```text
push GitHub
Azure Pipelines
npm test
docker build
docker push vers ACR
déploiement staging
smoke test
approbation production
swap
rollback possible
```

Cet exercice sert de récapitulatif final du cours.
