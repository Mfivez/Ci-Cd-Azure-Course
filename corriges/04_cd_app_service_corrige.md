# Corrigé 4 — Déployer une image sur App Service

```yaml
- stage: Deploy_Dev
  dependsOn: Push_ACR
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
