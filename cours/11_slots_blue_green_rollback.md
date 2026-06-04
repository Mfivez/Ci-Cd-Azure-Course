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
