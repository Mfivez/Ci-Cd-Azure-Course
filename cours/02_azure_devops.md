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
