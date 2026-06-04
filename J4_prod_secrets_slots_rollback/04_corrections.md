# J4 — Corrections

## Correction atelier 1

Choix recommandés :

- A : oui, approval humaine ;
- B : oui, main uniquement ;
- C : oui, un seul déploiement à la fois ;
- D : non ;
- E : oui, smoke test.

## Correction atelier 2

| Élément | Type |
|---|---|
| APP_NAME | variable |
| RESOURCE_GROUP | variable |
| ENVIRONMENT_NAME | variable |
| DATABASE_PASSWORD | secret |
| API_KEY | secret |
| LOG_LEVEL | variable |

## Correction atelier 3

Exemple :

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

              - script: curl -f https://croissant-web-prod-staging.azurewebsites.net/health
                displayName: 'Smoke test staging'

              - task: AzureAppServiceManage@0
                displayName: 'Swap staging vers production'
                inputs:
                  azureSubscription: 'Azure-Prod-SC'
                  Action: 'Swap Slots'
                  WebAppName: 'croissant-web-prod'
                  ResourceGroupName: 'rg-croissant-prod'
                  SourceSlot: 'staging'
                  SwapWithProduction: true

              - script: curl -f https://croissant-web-prod.azurewebsites.net/health
                displayName: 'Smoke test production'
```

## Correction atelier 4

1. Faire un swap inverse pour remettre v1 en production.
2. Les slots gardent l’ancienne version disponible à côté.
3. Vérifier `/health`, logs, erreurs, métriques et retours utilisateurs.
4. Non, il faut d’abord diagnostiquer v2. On peut la garder en staging pour investigation.

## Correction atelier 5

Pipeline attendu :

```text
Commit main
  ↓
CI : restore + tests + build
  ↓
Artefact drop
  ↓
Deploy Dev
  ↓
Smoke test Dev
  ↓
Deploy Staging
  ↓
Smoke test Staging
  ↓
Approval production
  ↓
Deploy slot staging
  ↓
Smoke test slot staging
  ↓
Swap production
  ↓
Smoke test production
  ↓
Monitoring
  ↓
Rollback possible par swap inverse
```

## Correction atelier 6

1. Faux.
2. Vrai.
3. Vrai.
4. Faux.
5. Vrai.
