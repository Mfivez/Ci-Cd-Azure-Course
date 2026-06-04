# J4 — Démo guidée — Production avec approval, slot staging, swap et rollback

## Objectif

Montrer le chemin complet vers la production sans déployer directement dessus.

Flux :

```text
Artefact validé
  ↓
Deploy slot staging
  ↓
Smoke test
  ↓
Approval
  ↓
Swap production
  ↓
Smoke test prod
```

## Préparation

Idéalement :

- App Service `croissant-web-prod` ;
- slot `staging` ;
- Azure DevOps Environment `croissant-production` ;
- approval configurée sur `croissant-production` ;
- Service Connection `Azure-Prod-SC`.

Mode simulation possible : remplacer les tasks Azure par des `echo`.

## Étape 1 — Créer l’environnement production

Navigation :

```text
Pipelines → Environments → New Environment
```

Nom :

```text
croissant-production
```

## Étape 2 — Ajouter une approval

Dans l’environnement :

```text
Approvals and Checks → Approvals → ajouter approver
```

Expliquer :

> Le pipeline peut arriver à la porte de la production, mais il attend une validation.

## Étape 3 — Ajouter Branch control si possible

Règle :

```text
seule main peut déployer
```

Expliquer :

> Même avec un mauvais YAML, l’environnement peut bloquer un déploiement depuis une branche non autorisée.

## Étape 4 — Stage production avec deployment job

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
              - download: current
                artifact: drop

              - script: echo "Déploiement production contrôlé"
```

À ce moment, le pipeline attend l’approbation.

## Étape 5 — Déployer vers le slot staging

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer sur slot staging'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-prod'
    deployToSlotOrASE: true
    resourceGroupName: 'rg-croissant-prod'
    slotName: 'staging'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## Étape 6 — Smoke test slot staging

```yaml
- script: |
    curl -f https://croissant-web-prod-staging.azurewebsites.net/health
  displayName: 'Smoke test slot staging'
```

## Étape 7 — Swap staging vers production

```yaml
- task: AzureAppServiceManage@0
  displayName: 'Swap staging vers production'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    Action: 'Swap Slots'
    WebAppName: 'croissant-web-prod'
    ResourceGroupName: 'rg-croissant-prod'
    SourceSlot: 'staging'
    SwapWithProduction: true
```

## Étape 8 — Smoke test production

```yaml
- script: |
    curl -f https://croissant-web-prod.azurewebsites.net/health
  displayName: 'Smoke test production'
```

## Étape 9 — Expliquer le rollback

Après le swap :

```text
production = nouvelle version
staging = ancienne version
```

Rollback :

```text
swap inverse
```

Commande conceptuelle :

```text
AzureAppServiceManage@0 → Swap Slots → SourceSlot staging → SwapWithProduction true
```

## Étape 10 — Montrer les Variable Groups

Navigation :

```text
Pipelines → Library → Variable Groups
```

Exemple :

```text
croissant-prod
  APP_NAME = croissant-web-prod
  RESOURCE_GROUP = rg-croissant-prod
  ENVIRONMENT_NAME = production
  DATABASE_PASSWORD = secret
```

## Étape 11 — Conclusion de la démo

Phrase :

> La production n’est pas seulement une cible de déploiement. C’est un environnement protégé, validé, observable et réversible.
