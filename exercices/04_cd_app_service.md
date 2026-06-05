# Exercice 4 — Déployer une image sur App Service

Compléter le stage `Deploy_Dev`.

Variables disponibles :

```yaml
variables:
  acrLoginServer: croissantregistrydemo.azurecr.io
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
  devAppName: croissant-api-dev
```

Pipeline à compléter :

```yaml
- stage: Deploy_Dev
  dependsOn: Push_ACR
  jobs:
    - deployment: DeployDev
      environment: ______
      strategy:
        runOnce:
          deploy:
            steps:
              - task: AzureWebAppContainer@1
                inputs:
                  azureSubscription: ______
                  appName: ______
                  containers: ______
```
