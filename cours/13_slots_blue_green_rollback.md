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
