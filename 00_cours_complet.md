# 1. Le cycle de vie applicatif

Une application ne se limite pas au code écrit par les développeurs. Elle possède un cycle de vie complet : elle est conçue, développée, testée, validée, déployée, surveillée puis corrigée au fil du temps.

Dans une équipe, ce cycle doit être organisé. Si chaque personne construit, teste et déploie à sa manière, le projet devient vite difficile à contrôler. Le rôle d’une démarche DevOps est de rendre ce cycle plus fiable, plus automatisé et plus traçable.

## Du code à la production

Le chemin classique d’une modification ressemble à ceci :

```text
une demande métier
  ↓
une branche Git
  ↓
du code
  ↓
une pull request
  ↓
des validations automatiques
  ↓
un artefact
  ↓
un déploiement
  ↓
une version en production
```

Chaque étape ajoute un niveau de confiance.

Le code seul ne suffit pas. Il faut pouvoir répondre à des questions très concrètes :

```text
Qui a modifié cette fonctionnalité ?
Quels tests ont été exécutés ?
Quelle version est actuellement en production ?
Comment revenir à la version précédente ?
Où sont stockés les secrets ?
Qui a validé le passage en production ?
```

Un bon pipeline CI/CD permet de répondre à ces questions.

## Intégration continue

L’intégration continue, ou **CI** pour *Continuous Integration*, consiste à vérifier automatiquement le code dès qu’il est proposé dans le repository.

Elle répond à la question :

> Est-ce que le code peut être intégré sans casser l’application ?

Une CI classique exécute plusieurs étapes :

```text
récupérer le code
  ↓
installer les dépendances
  ↓
compiler ou préparer l’application
  ↓
lancer les tests
  ↓
publier les résultats
  ↓
produire un artefact
```

La CI détecte les problèmes tôt. Plus un bug est découvert tard, plus il coûte cher à corriger.

## Déploiement continu

Le déploiement continu, ou **CD** pour *Continuous Delivery* ou *Continuous Deployment*, prend le relais après la CI.

Il répond à la question :

> Comment mettre une version validée dans le bon environnement ?

Un CD classique ressemble à ceci :

```text
prendre l’artefact validé
  ↓
choisir un environnement cible
  ↓
appliquer la configuration de cet environnement
  ↓
déployer
  ↓
vérifier que l’application répond
  ↓
promouvoir vers l’environnement suivant
```

La différence entre les deux sens de CD est importante :

| Terme | Sens |
|---|---|
| Continuous Delivery | la version est prête à être livrée, mais une validation humaine peut être demandée |
| Continuous Deployment | la version est déployée automatiquement jusqu’en production |

Dans beaucoup d’entreprises, le déploiement en production reste protégé par une approbation humaine.

## Environnements

Une application passe généralement par plusieurs environnements avant d’arriver aux utilisateurs réels.

```text
local → dev → test/staging → production
```

| Environnement | Rôle |
|---|---|
| local | machine du développeur |
| dev | intégration rapide des changements |
| test / staging | validation proche de la production |
| production | environnement utilisé par les vrais utilisateurs |

Un environnement n’est pas seulement une URL. C’est un ensemble de ressources et de paramètres :

```text
application
base de données
variables de configuration
secrets
logs
monitoring
permissions
règles de déploiement
```

La règle importante est la suivante :

> On évite de changer le code entre les environnements. On change la configuration.

Exemple :

| Élément | Dev | Production |
|---|---|---|
| URL API | `https://api-dev.example.com` | `https://api.example.com` |
| Base de données | `croissant-dev-db` | `croissant-prod-db` |
| Logs | détaillés | contrôlés |
| Secrets | secrets de test | secrets réels |

## Artefact

Un artefact est le résultat exploitable d’un build.

Exemples :

```text
un fichier .zip
une image Docker
un package NuGet
un package npm
un fichier .jar
un dossier dist/
```

La pratique recommandée est souvent résumée ainsi :

> Build once, deploy everywhere.

Cela signifie que l’application est construite une seule fois, puis que le même artefact est déployé dans les différents environnements.

On évite ce scénario :

```text
build spécifique pour dev
build spécifique pour test
build spécifique pour prod
```

On préfère :

```text
un seul build
  ↓
un seul artefact
  ↓
déploiement en dev
  ↓
déploiement en staging
  ↓
déploiement en production
```

Cette approche réduit les écarts entre ce qui a été testé et ce qui est réellement mis en production.
# 2. Azure DevOps dans le cycle de vie

Azure DevOps est une plateforme qui regroupe plusieurs services utilisés dans le cycle de vie applicatif.

Dans ce cours, l’application **Croissant API** passera par ces services :

```text
Azure Boards      → suivre le travail
Azure Repos       → versionner le code
Azure Pipelines   → construire, tester et déployer
Azure Artifacts   → stocker des packages ou artefacts
Azure Test Plans  → organiser des tests manuels avancés
```

Le cœur du cours est **Azure Pipelines**, mais les autres services donnent le contexte.

## Organisation, projet et repository

Azure DevOps est structuré en niveaux.

```text
Organisation
  └── Projet
        ├── Repos
        ├── Pipelines
        ├── Boards
        ├── Artifacts
        └── Environments
```

Une **organisation** représente généralement une entreprise, une entité ou un espace de travail global.

Un **projet** regroupe les éléments liés à une application, un produit ou une équipe.

Un **repository** contient le code source.

Pour Croissant API, on peut imaginer :

```text
Organisation : BoulangerieCloud
Projet       : CroissantAPI
Repository   : croissant-api
```

## Azure Boards

Azure Boards sert à suivre le travail.

On y trouve des éléments comme :

```text
Epic
Feature
User Story
Task
Bug
```

Exemple :

```text
Feature : Exposer une API de commande
User Story : En tant que client, je veux consulter la liste des croissants disponibles
Task : Créer la route GET /croissants
Bug : La route /health retourne une erreur 500
```

Dans un cycle DevOps complet, les work items peuvent être reliés aux branches, commits, pull requests et déploiements.

## Azure Repos

Azure Repos héberge le code source Git.

Il permet de travailler avec :

```text
commits
branches
pull requests
politiques de branches
historique du code
```

Le repository est le point de départ du pipeline. Quand du code est poussé sur une branche, Azure Pipelines peut démarrer automatiquement.

## Azure Pipelines

Azure Pipelines est le service qui exécute la CI/CD.

Il automatise :

```text
installation des dépendances
build
tests
publication d’artefact
déploiement
approbations
promotion entre environnements
```

Un pipeline peut être défini dans un fichier YAML versionné avec le code.

Exemple de fichier :

```text
azure-pipelines.yml
```

Ce fichier devient une partie du projet. Il peut être relu en pull request, modifié, historisé et restauré.

## Azure Artifacts

Azure Artifacts sert à héberger des packages privés.

Exemples :

```text
packages npm
packages NuGet
packages Maven
packages Python
```

Dans le cas d’un pipeline, le mot **artefact** peut aussi désigner le résultat publié par le build : un zip, un dossier ou un package prêt à déployer.

## Environments dans Azure DevOps

Les **Environments** d’Azure DevOps représentent des cibles de déploiement.

Exemples :

```text
croissant-dev
croissant-staging
croissant-production
```

Ils permettent de garder un historique des déploiements et d’ajouter des protections.

Pour la production, on peut demander :

```text
approbation manuelle
contrôle de branche
verrouillage pour éviter deux déploiements simultanés
vérification d’alertes de monitoring
```

## Le chemin complet dans Azure DevOps

Le parcours de Croissant API peut être résumé ainsi :

```text
Work Item dans Boards
  ↓
branche Git dans Repos
  ↓
pull request
  ↓
pipeline CI dans Pipelines
  ↓
artefact publié
  ↓
pipeline CD
  ↓
environnement Azure DevOps
  ↓
application déployée sur Azure
```

Cette chaîne donne de la traçabilité : une version déployée peut être reliée au code, aux tests et aux demandes métier d’origine.
# 3. Git, branches et pull requests

Le pipeline CI/CD commence avec un repository Git propre.

Pour Croissant API, le code est stocké dans un repository Azure Repos. Les développeurs ne travaillent pas directement sur la branche principale. Ils créent des branches courtes, proposent leurs changements via pull request, puis la CI vérifie automatiquement le résultat.

## Branche principale

La branche principale s’appelle généralement `main`.

Elle représente la version stable du code.

```text
main
```

Une règle saine consiste à protéger cette branche :

```text
pas de push direct sur main
passage obligatoire par pull request
build obligatoire avant merge
revue de code obligatoire
```

## Branches de travail

Une branche de travail permet de développer sans casser `main`.

Exemples de noms :

```text
feature/add-health-endpoint
feature/123-add-croissant-list
bugfix/fix-health-route
hotfix/fix-production-crash
```

Une branche doit rester courte. Plus une branche vit longtemps, plus elle risque de diverger de `main`.

## Commit

Un commit représente une modification enregistrée dans l’historique Git.

Un bon message de commit explique ce qui change.

Exemples :

```text
feat: add health endpoint
fix: return 200 on health check
test: add health endpoint test
ci: add node pipeline
```

Les messages structurés facilitent la génération de notes de version et la compréhension de l’historique.

## Pull request

Une pull request est une demande d’intégration d’une branche dans une autre.

Dans Azure Repos, une PR permet de :

```text
relire le code
commenter les changements
lier un work item
exécuter un pipeline de validation
bloquer le merge si la CI échoue
conserver une trace de validation
```

Flux classique :

```text
créer une branche
  ↓
modifier le code
  ↓
pousser la branche
  ↓
ouvrir une pull request
  ↓
CI automatique
  ↓
review
  ↓
merge vers main
```

## Policies de branche

Les branch policies sont des règles appliquées à une branche.

Pour `main`, on peut imposer :

```text
nombre minimum de reviewers
build obligatoire réussi
work item lié
commentaires résolus
interdiction du push direct
```

Ces règles transforment une bonne pratique en contrainte technique.

Sans policies, l’équipe dépend uniquement de la discipline humaine.

Avec policies, Azure DevOps empêche automatiquement les actions dangereuses.

## Exemple avec Croissant API

Un développeur doit ajouter une route `/health`.

```text
main
  ↓
feature/add-health-endpoint
  ↓
commit : feat: add health endpoint
  ↓
pull request vers main
  ↓
CI : npm install + npm test
  ↓
review
  ↓
merge
```

La CI devient un garde-fou. Si le test échoue, la pull request ne doit pas être mergée.
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
# 6. Artefacts de build

Un artefact est ce que le pipeline produit pour être réutilisé ensuite.

Dans une chaîne CI/CD, le pipeline de CI ne doit pas seulement dire “les tests sont verts”. Il doit aussi produire une version exploitable de l’application.

## Pourquoi publier un artefact

Sans artefact, le CD risque de reconstruire l’application au moment du déploiement.

Cela pose un problème :

```text
ce qui est testé n’est pas forcément ce qui est déployé
```

Avec un artefact :

```text
CI construit une version
CI teste cette version
CD déploie cette même version
```

C’est le principe :

```text
Build once, deploy everywhere
```

## Artefact pour Croissant API

Pour Croissant API, on peut créer un fichier zip contenant :

```text
package.json
package-lock.json
src/
test/
```

Dans un vrai projet, on adapterait le contenu selon la technologie.

## Préparer le contenu

On peut copier les fichiers nécessaires dans un dossier temporaire :

```yaml
- script: |
    mkdir -p $(Build.ArtifactStagingDirectory)/app
    cp package*.json $(Build.ArtifactStagingDirectory)/app/
    cp -r src $(Build.ArtifactStagingDirectory)/app/src
  displayName: "Préparer l’artefact"
```

`$(Build.ArtifactStagingDirectory)` est une variable intégrée d’Azure Pipelines. Elle pointe vers un dossier prévu pour préparer les fichiers à publier.

## Publier l’artefact

Azure Pipelines fournit une tâche dédiée :

```yaml
- task: PublishPipelineArtifact@1
  displayName: "Publier l’artefact"
  inputs:
    targetPath: "$(Build.ArtifactStagingDirectory)/app"
    artifact: "croissant-api"
    publishLocation: "pipeline"
```

L’artefact devient disponible dans le run du pipeline.

## Télécharger l’artefact dans un autre stage

Un stage de déploiement peut télécharger l’artefact :

```yaml
- task: DownloadPipelineArtifact@2
  displayName: "Télécharger l’artefact"
  inputs:
    artifact: "croissant-api"
    path: "$(Pipeline.Workspace)/croissant-api"
```

Cela permet de séparer clairement :

```text
CI : construire et tester
CD : déployer ce qui a été construit
```

## Pipeline avec artefact

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
        displayName: "Construire et publier"
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

          - script: |
              mkdir -p $(Build.ArtifactStagingDirectory)/app
              cp package*.json $(Build.ArtifactStagingDirectory)/app/
              cp -r src $(Build.ArtifactStagingDirectory)/app/src
            displayName: "Préparer l’artefact"

          - task: PublishPipelineArtifact@1
            displayName: "Publier l’artefact"
            inputs:
              targetPath: "$(Build.ArtifactStagingDirectory)/app"
              artifact: "croissant-api"
              publishLocation: "pipeline"
```

## Versionner un artefact

Azure Pipelines expose des variables utiles :

| Variable | Utilisation |
|---|---|
| `$(Build.BuildId)` | identifiant unique du run |
| `$(Build.SourceBranchName)` | branche source |
| `$(Build.Repository.Name)` | nom du repository |
| `$(Build.ArtifactStagingDirectory)` | dossier de préparation |

On peut les utiliser pour nommer ou tracer les livraisons.

Exemple :

```text
croissant-api-$(Build.BuildId)
```

L’identifiant du build permet de retrouver exactement quel pipeline a produit quelle version.
# 7. Déploiement continu et environnements

Une fois l’artefact produit, le pipeline peut le déployer.

Le CD commence là où la CI s’arrête.

```text
CI : produire une version fiable
CD : envoyer cette version dans un environnement
```

## Chaîne de promotion

Une application n’est généralement pas envoyée directement en production.

Elle passe par une chaîne de promotion :

```text
Dev → Staging → Production
```

Chaque étape ajoute une validation.

| Environnement | Déploiement | Validation |
|---|---|---|
| Dev | automatique | vérification rapide |
| Staging | automatique ou semi-automatique | tests fonctionnels |
| Production | protégé | approbation et monitoring |

## Stage de déploiement

Un stage de déploiement peut télécharger l’artefact et l’envoyer vers une cible.

Exemple simplifié :

```yaml
- stage: Deploy_Dev
  displayName: "Déploiement Dev"
  dependsOn: Build
  jobs:
    - job: DeployDev
      displayName: "Déployer en Dev"
      steps:
        - task: DownloadPipelineArtifact@2
          inputs:
            artifact: "croissant-api"
            path: "$(Pipeline.Workspace)/croissant-api"

        - script: echo "Déploiement en Dev"
```

`dependsOn` indique que le déploiement dépend du stage précédent.

## Jobs de déploiement

Azure Pipelines propose un type de job spécial : `deployment`.

Il permet de cibler un environnement Azure DevOps.

```yaml
- stage: Deploy_Staging
  displayName: "Déploiement Staging"
  dependsOn: Build
  jobs:
    - deployment: DeployStaging
      displayName: "Déployer en Staging"
      environment: "croissant-staging"
      strategy:
        runOnce:
          deploy:
            steps:
              - script: echo "Déploiement dans l’environnement staging"
```

L’intérêt de `environment` est de lier le pipeline à un environnement Azure DevOps.

Cela permet :

```text
historique des déploiements
approbations
checks
traçabilité
protection de la production
```

## Enchaîner les environnements

```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "Build"

  - stage: Deploy_Dev
    dependsOn: Build
    jobs:
      - deployment: DeployDev
        environment: "croissant-dev"
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploy Dev"

  - stage: Deploy_Staging
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        environment: "croissant-staging"
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploy Staging"
```

Ici, staging attend que dev soit terminé.

## Smoke test

Après un déploiement, on exécute souvent un test très simple appelé **smoke test**.

Il vérifie que l’application répond.

Exemple :

```bash
curl https://croissant-api-staging.azurewebsites.net/health
```

Dans un pipeline :

```yaml
- script: |
    curl --fail https://$(APP_HOSTNAME)/health
  displayName: "Smoke test"
```

Si le smoke test échoue, le pipeline s’arrête.

## Déploiement direct ou promotion

Deux approches existent.

Approche moins fiable :

```text
build dev
build staging
build production
```

Approche plus fiable :

```text
build unique
  ↓
artefact unique
  ↓
déploiement dev
  ↓
déploiement staging
  ↓
déploiement production
```

Le CD doit favoriser la promotion de la même version.
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
# 9. Variables, secrets et Key Vault

Un pipeline a besoin de configuration.

Certaines valeurs ne sont pas sensibles :

```text
nom d’une application
nom d’un resource group
nom d’un environnement
URL publique
```

D’autres valeurs sont sensibles :

```text
mot de passe
clé API
token
chaîne de connexion
certificat
```

Il faut distinguer **variables** et **secrets**.

## Variables non sensibles

Une variable non sensible peut être écrite dans le YAML si elle ne pose pas de risque.

```yaml
variables:
  appName: "app-croissant-dev"
  environmentName: "dev"
```

Utilisation :

```yaml
- script: echo "Déploiement de $(appName)"
```

## Secrets

Un secret ne doit jamais être écrit dans le code ni dans le YAML.

Mauvais exemple :

```yaml
variables:
  databasePassword: "SuperPassword123"
```

Bon principe :

```text
le YAML référence le secret
le secret est stocké dans un espace sécurisé
la valeur est masquée dans les logs
```

## Variable Groups

Dans Azure DevOps, les Variable Groups se trouvent dans :

```text
Pipelines → Library → Variable groups
```

Un variable group permet de centraliser des variables utilisées par plusieurs pipelines.

Exemple :

```text
croissant-dev-vars
croissant-staging-vars
croissant-prod-vars
```

On peut y stocker :

```text
APP_NAME
APP_HOSTNAME
RESOURCE_GROUP
DATABASE_URL
```

Les variables sensibles doivent être marquées comme secrètes.

## Utiliser un Variable Group dans YAML

```yaml
variables:
  - group: croissant-dev-vars
```

Puis :

```yaml
- script: echo "Application : $(APP_NAME)"
```

## Variables par environnement

Pour éviter de mélanger dev, staging et production, on peut utiliser des groupes séparés.

```yaml
variables:
  - group: croissant-staging-vars
```

Puis le stage staging utilise les valeurs staging.

La production peut utiliser un autre groupe :

```yaml
variables:
  - group: croissant-prod-vars
```

## Azure Key Vault

Azure Key Vault est le coffre-fort Azure pour les secrets.

Il sert à stocker :

```text
secrets applicatifs
certificats
clés cryptographiques
chaînes de connexion
```

Dans une approche plus propre, Azure DevOps ne stocke pas directement tous les secrets. Il les lit depuis Key Vault.

## Lier un Variable Group à Key Vault

Un variable group peut être lié à un Azure Key Vault.

Le pipeline accède alors aux secrets sans les écrire dans le YAML.

Exemple conceptuel :

```yaml
variables:
  - group: croissant-keyvault-secrets
```

Puis :

```yaml
- script: echo "Le secret existe mais sa valeur ne doit pas être affichée"
```

## Règles importantes

```text
ne jamais committer un secret
ne jamais afficher un secret avec echo
ne jamais partager un token personnel
utiliser des secrets différents par environnement
limiter les droits des Service Connections
supprimer et renouveler un secret exposé
```

## Exemple avec Croissant API

L’application peut lire une variable d’environnement :

```text
ENVIRONMENT_NAME=staging
```

Elle peut aussi lire une chaîne de connexion :

```text
DATABASE_CONNECTION_STRING
```

La première valeur peut être une variable simple.
La deuxième doit être un secret.

## Configuration dans App Service

Azure App Service possède des **Application Settings**.

Ces settings deviennent des variables d’environnement pour l’application.

Exemples :

```text
ENVIRONMENT_NAME=Production
LOG_LEVEL=Warning
DATABASE_CONNECTION_STRING=secret
```

Le pipeline peut déployer l’application, mais la configuration de l’environnement doit rester séparée du code.
# 10. Approbations, checks et production

La production est l’environnement le plus sensible.

Un déploiement en production peut impacter de vrais utilisateurs, des données réelles et l’image de l’entreprise.

Pour cette raison, le pipeline ne doit pas traiter la production comme un environnement ordinaire.

## Protection de la production

Un déploiement en production peut être protégé par :

```text
approbation manuelle
contrôle de branche
vérification d’alertes
verrouillage exclusif
restriction des permissions
historique des déploiements
```

Azure DevOps permet de configurer ces protections sur les **Environments**.

## Environnement production

Dans Azure DevOps :

```text
Pipelines → Environments → New environment
```

Nom possible :

```text
croissant-production
```

Un stage de pipeline peut cibler cet environnement :

```yaml
- stage: Deploy_Production
  displayName: "Déploiement Production"
  jobs:
    - deployment: DeployProduction
      environment: "croissant-production"
      strategy:
        runOnce:
          deploy:
            steps:
              - script: echo "Déploiement production"
```

## Approbation manuelle

Une approbation manuelle bloque le pipeline jusqu’à ce qu’une personne autorisée valide.

Flux :

```text
staging réussi
  ↓
pipeline demande validation production
  ↓
approbateur vérifie
  ↓
approbation
  ↓
déploiement production
```

L’approbation ajoute une trace :

```text
qui a approuvé
quand
pour quel déploiement
```

## Branch control

La production ne devrait pas accepter un déploiement depuis n’importe quelle branche.

Règle classique :

```text
seule main peut aller en production
```

Cela évite qu’une branche de fonctionnalité soit déployée accidentellement.

## Exclusive lock

Un verrou exclusif empêche deux déploiements simultanés sur le même environnement.

Sans verrou :

```text
pipeline A déploie
pipeline B déploie en même temps
résultat incertain
```

Avec verrou :

```text
pipeline A déploie
pipeline B attend
```

## Production dans le YAML

Exemple :

```yaml
- stage: Deploy_Production
  displayName: "Déploiement Production"
  dependsOn: Deploy_Staging
  jobs:
    - deployment: DeployProduction
      displayName: "Déployer en Production"
      environment: "croissant-production"
      strategy:
        runOnce:
          deploy:
            steps:
              - task: DownloadPipelineArtifact@2
                inputs:
                  artifact: "croissant-api"
                  path: "$(Pipeline.Workspace)/croissant-api"

              - task: AzureWebApp@1
                displayName: "Déployer sur App Service Production"
                inputs:
                  azureSubscription: "$(azureServiceConnection)"
                  appType: "webAppLinux"
                  appName: "$(prodAppName)"
                  package: "$(Pipeline.Workspace)/croissant-api"
```

La protection n’est pas seulement dans le YAML. Elle se configure aussi sur l’environnement Azure DevOps.

## Vérification après production

Après le déploiement, il faut vérifier que l’application répond.

```yaml
- script: |
    curl --fail https://$(prodAppName).azurewebsites.net/health
  displayName: "Smoke test production"
```

Un smoke test ne remplace pas tous les tests fonctionnels. Il vérifie seulement que la version déployée est vivante.

## Responsabilité du passage en production

Un bon pipeline rend le déploiement reproductible.

Mais la décision de production peut rester humaine.

Avant d’approuver, on peut vérifier :

```text
la CI est verte
l’artefact est identifié
staging est validé
les tests importants sont passés
aucune alerte critique n’est active
un rollback est possible
```

La production n’est pas un simple bouton. C’est une étape contrôlée.
# 11. Deployment slots, Blue/Green et rollback

Déployer directement sur la production peut être risqué.

Avec Azure App Service, on peut utiliser des **deployment slots** pour réduire ce risque.

Un slot est une instance parallèle de l’application.

Exemple :

```text
app-croissant-prod
  ├── production
  └── staging
```

Le slot `production` reçoit le trafic réel.
Le slot `staging` reçoit la nouvelle version avant bascule.

## Déploiement direct

Déploiement direct :

```text
pipeline → production
```

Risque :

```text
si la nouvelle version est mauvaise, les utilisateurs sont immédiatement impactés
```

## Déploiement avec slot staging

Déploiement plus sûr :

```text
pipeline → slot staging
  ↓
smoke tests
  ↓
swap staging → production
```

Le slot staging permet de tester la nouvelle version avant de l’exposer aux utilisateurs.

## Blue/Green

Le principe Blue/Green consiste à avoir deux versions disponibles.

```text
Blue  = version actuellement en production
Green = nouvelle version préparée à côté
```

Quand Green est validée, on bascule le trafic.

Avec Azure App Service :

```text
production = Blue
staging    = Green
```

Après swap :

```text
production = Green
staging    = Blue
```

## Déployer sur un slot

Avec `AzureWebApp@1` :

```yaml
- task: AzureWebApp@1
  displayName: "Déployer sur le slot staging"
  inputs:
    azureSubscription: "$(azureServiceConnection)"
    appType: "webAppLinux"
    appName: "$(prodAppName)"
    deployToSlotOrASE: true
    resourceGroupName: "$(resourceGroupName)"
    slotName: "staging"
    package: "$(Pipeline.Workspace)/croissant-api"
```

Ici, on ne déploie pas directement sur production. On déploie sur le slot `staging` de l’application de production.

## Smoke test sur le slot

```yaml
- script: |
    curl --fail https://$(prodAppName)-staging.azurewebsites.net/health
  displayName: "Smoke test slot staging"
```

Si le slot ne répond pas correctement, le pipeline ne doit pas faire le swap.

## Swap vers production

Le swap échange le slot staging et la production.

```yaml
- task: AzureAppServiceManage@0
  displayName: "Swap staging vers production"
  inputs:
    azureSubscription: "$(azureServiceConnection)"
    Action: "Swap Slots"
    WebAppName: "$(prodAppName)"
    ResourceGroupName: "$(resourceGroupName)"
    SourceSlot: "staging"
    SwapWithProduction: true
```

Après le swap, la nouvelle version reçoit le trafic réel.

## Rollback

Le rollback consiste à revenir à une version précédente.

Avec les slots, le rollback peut être très rapide.

Avant incident :

```text
production = v2
staging    = v1
```

Rollback :

```text
swap inverse
```

Après rollback :

```text
production = v1
staging    = v2
```

Le slot staging garde l’ancienne version juste après le swap. C’est ce qui rend le retour arrière rapide.

## Pipeline avec slot et swap

```yaml
- stage: Deploy_Production
  displayName: "Déploiement Production"
  dependsOn: Deploy_Staging
  jobs:
    - deployment: DeployProduction
      environment: "croissant-production"
      strategy:
        runOnce:
          deploy:
            steps:
              - task: DownloadPipelineArtifact@2
                inputs:
                  artifact: "croissant-api"
                  path: "$(Pipeline.Workspace)/croissant-api"

              - task: AzureWebApp@1
                displayName: "Déployer sur le slot staging"
                inputs:
                  azureSubscription: "$(azureServiceConnection)"
                  appType: "webAppLinux"
                  appName: "$(prodAppName)"
                  deployToSlotOrASE: true
                  resourceGroupName: "$(resourceGroupName)"
                  slotName: "staging"
                  package: "$(Pipeline.Workspace)/croissant-api"

              - script: |
                  curl --fail https://$(prodAppName)-staging.azurewebsites.net/health
                displayName: "Smoke test slot staging"

              - task: AzureAppServiceManage@0
                displayName: "Swap staging vers production"
                inputs:
                  azureSubscription: "$(azureServiceConnection)"
                  Action: "Swap Slots"
                  WebAppName: "$(prodAppName)"
                  ResourceGroupName: "$(resourceGroupName)"
                  SourceSlot: "staging"
                  SwapWithProduction: true
```

## Ce que les slots apportent

```text
déploiement sans écraser immédiatement la production
test sur environnement parallèle
bascule rapide
rollback simple
réduction du stress de mise en production
```

Les slots ne remplacent pas les tests, mais ils rendent la mise en production plus contrôlée.
# 12. Pipeline complet

Le pipeline complet de Croissant API assemble les notions précédentes :

```text
build
  ↓
tests
  ↓
publication d’artefact
  ↓
déploiement dev
  ↓
déploiement staging
  ↓
déploiement production protégé
  ↓
slot swap
```

## Vue d’ensemble

```text
push sur main
  ↓
stage Build
  ↓
artefact croissant-api
  ↓
stage Deploy_Dev
  ↓
stage Deploy_Staging
  ↓
stage Deploy_Production
```

Le même artefact est utilisé partout.

## YAML complet

```yaml
trigger:
  - main

pr:
  - main

pool:
  vmImage: ubuntu-latest

variables:
  azureServiceConnection: "sc-azure-croissant"
  resourceGroupName: "rg-croissant-demo"
  devAppName: "app-croissant-dev"
  stagingAppName: "app-croissant-staging"
  prodAppName: "app-croissant-prod"

stages:
  - stage: Build
    displayName: "Build et tests"
    jobs:
      - job: BuildJob
        displayName: "Construire Croissant API"
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

          - script: |
              mkdir -p $(Build.ArtifactStagingDirectory)/app
              cp package*.json $(Build.ArtifactStagingDirectory)/app/
              cp -r src $(Build.ArtifactStagingDirectory)/app/src
            displayName: "Préparer l’artefact"

          - task: PublishPipelineArtifact@1
            displayName: "Publier l’artefact"
            inputs:
              targetPath: "$(Build.ArtifactStagingDirectory)/app"
              artifact: "croissant-api"
              publishLocation: "pipeline"

  - stage: Deploy_Dev
    displayName: "Déploiement Dev"
    dependsOn: Build
    jobs:
      - deployment: DeployDev
        displayName: "Déployer en Dev"
        environment: "croissant-dev"
        strategy:
          runOnce:
            deploy:
              steps:
                - task: DownloadPipelineArtifact@2
                  displayName: "Télécharger l’artefact"
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

                - script: |
                    curl --fail https://$(devAppName).azurewebsites.net/health
                  displayName: "Smoke test Dev"

  - stage: Deploy_Staging
    displayName: "Déploiement Staging"
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        displayName: "Déployer en Staging"
        environment: "croissant-staging"
        strategy:
          runOnce:
            deploy:
              steps:
                - task: DownloadPipelineArtifact@2
                  displayName: "Télécharger l’artefact"
                  inputs:
                    artifact: "croissant-api"
                    path: "$(Pipeline.Workspace)/croissant-api"

                - task: AzureWebApp@1
                  displayName: "Déployer sur App Service Staging"
                  inputs:
                    azureSubscription: "$(azureServiceConnection)"
                    appType: "webAppLinux"
                    appName: "$(stagingAppName)"
                    package: "$(Pipeline.Workspace)/croissant-api"

                - script: |
                    curl --fail https://$(stagingAppName).azurewebsites.net/health
                  displayName: "Smoke test Staging"

  - stage: Deploy_Production
    displayName: "Déploiement Production"
    dependsOn: Deploy_Staging
    jobs:
      - deployment: DeployProduction
        displayName: "Déployer en Production"
        environment: "croissant-production"
        strategy:
          runOnce:
            deploy:
              steps:
                - task: DownloadPipelineArtifact@2
                  displayName: "Télécharger l’artefact"
                  inputs:
                    artifact: "croissant-api"
                    path: "$(Pipeline.Workspace)/croissant-api"

                - task: AzureWebApp@1
                  displayName: "Déployer sur le slot staging"
                  inputs:
                    azureSubscription: "$(azureServiceConnection)"
                    appType: "webAppLinux"
                    appName: "$(prodAppName)"
                    deployToSlotOrASE: true
                    resourceGroupName: "$(resourceGroupName)"
                    slotName: "staging"
                    package: "$(Pipeline.Workspace)/croissant-api"

                - script: |
                    curl --fail https://$(prodAppName)-staging.azurewebsites.net/health
                  displayName: "Smoke test slot staging"

                - task: AzureAppServiceManage@0
                  displayName: "Swap staging vers production"
                  inputs:
                    azureSubscription: "$(azureServiceConnection)"
                    Action: "Swap Slots"
                    WebAppName: "$(prodAppName)"
                    ResourceGroupName: "$(resourceGroupName)"
                    SourceSlot: "staging"
                    SwapWithProduction: true

                - script: |
                    curl --fail https://$(prodAppName).azurewebsites.net/health
                  displayName: "Smoke test Production"
```

## Lecture du pipeline

Le stage `Build` produit l’artefact.

```text
npm ci
npm test
préparation de l’artefact
publication de l’artefact
```

Le stage `Deploy_Dev` déploie automatiquement en dev.

Le stage `Deploy_Staging` attend dev.

Le stage `Deploy_Production` attend staging et cible l’environnement `croissant-production`.

La protection production est configurée sur l’environnement Azure DevOps.

Le déploiement production se fait d’abord sur le slot `staging`, puis le pipeline effectue un swap.

## Points à adapter

Les valeurs suivantes doivent correspondre au projet réel :

```text
azureServiceConnection
resourceGroupName
devAppName
stagingAppName
prodAppName
noms des environnements Azure DevOps
```

Le pipeline est une base. Selon le projet, on peut ajouter :

```text
analyse SonarCloud
scan de dépendances
publication de couverture de tests
notifications Teams
Key Vault
templates YAML
```
# 13. Bonnes pratiques

Un pipeline CI/CD doit être fiable, lisible et sécurisé.

Le but n’est pas seulement d’automatiser. Le but est d’automatiser proprement.

## Versionner le pipeline

Le fichier YAML doit être dans le repository.

```text
azure-pipelines.yml
```

Avantages :

```text
historique Git
review en pull request
rollback
traçabilité
cohérence avec le code
```

## Garder les branches courtes

Les branches longues compliquent l’intégration.

Préférer :

```text
petites branches
petites pull requests
feedback rapide
merge fréquent
```

## Protéger main

La branche `main` doit être protégée.

Règles recommandées :

```text
pas de push direct
pull request obligatoire
review obligatoire
build obligatoire
work item lié si le projet utilise Boards
```

## Faire échouer le pipeline en cas de problème

Un pipeline qui masque les erreurs n’est pas fiable.

Les commandes importantes doivent retourner une erreur si elles échouent.

Exemple :

```bash
curl --fail https://app.example.com/health
```

Sans `--fail`, certains problèmes HTTP peuvent passer inaperçus.

## Construire une seule fois

Éviter :

```text
rebuild pour dev
rebuild pour staging
rebuild pour prod
```

Préférer :

```text
un build
un artefact
plusieurs déploiements
```

## Séparer code et configuration

Le code doit rester le même entre les environnements.

La configuration change :

```text
nom de base de données
URL API
niveau de logs
secrets
feature flags
```

## Ne jamais committer un secret

Interdits :

```text
mot de passe dans le code
token dans le YAML
fichier .env commité
clé privée dans le repository
```

À utiliser :

```text
variables secrètes
Variable Groups
Azure Key Vault
Service Connections limitées
```

## Limiter les permissions

Une Service Connection ne doit pas avoir plus de droits que nécessaire.

Principe :

```text
le pipeline dev ne doit pas pouvoir déployer en production
un pipeline inconnu ne doit pas accéder aux secrets production
les admins production doivent être peu nombreux
```

## Utiliser les environnements Azure DevOps

Les environnements apportent :

```text
historique de déploiement
approbations
checks
contrôle de branche
verrouillage exclusif
```

La production doit être un environnement protégé.

## Prévoir le rollback

Un rollback ne doit pas être improvisé pendant un incident.

Il doit être pensé avant.

Avec App Service slots :

```text
swap vers production
si problème : swap inverse
```

## Ajouter du monitoring

Un déploiement réussi techniquement ne suffit pas.

Il faut surveiller :

```text
taux d’erreur
latence
logs applicatifs
alertes Azure Monitor
résultat des smoke tests
```

## Garder le YAML lisible

Un pipeline trop long devient difficile à maintenir.

Bonnes pratiques :

```text
noms clairs pour les stages
noms clairs pour les steps
variables explicites
templates pour les blocs répétés
commentaires seulement quand ils aident vraiment
```

## Améliorations possibles

Une fois la base stable, on peut ajouter :

```text
quality gate SonarCloud
scan des dépendances
scan des secrets
scan d’images Docker
notifications Teams
métriques DORA
templates partagés
Infrastructure as Code
```

Ces améliorations renforcent la chaîne sans changer son principe de base :

```text
code → CI → artefact → CD → environnements → production contrôlée
```
