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
