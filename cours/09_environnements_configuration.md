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
