# Chapitre 15 — Pipeline complet end-to-end

Le pipeline complet Docker-first suit tout le trajet.

```text
GitHub
   ↓
Tests
   ↓
Build image Docker
   ↓
Push vers Azure Container Registry
   ↓
Deploy vers dev
   ↓
Deploy vers staging slot
   ↓
Smoke test staging
   ↓
Approval production
   ↓
Swap staging vers production
```

## Version complète

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

variables:
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
  acrLoginServer: croissantregistrydemo.azurecr.io
  resourceGroupName: rg-croissant-demo
  devAppName: croissant-api-dev
  prodAppName: croissant-api-prod
  stagingSlotName: staging

stages:
  - stage: Test
    displayName: "Tests"
    jobs:
      - job: TestNode
        steps:
          - checkout: self
          - script: npm test
            displayName: "Tests Node.js"

  - stage: Build_Image
    displayName: "Build image Docker"
    dependsOn: Test
    jobs:
      - job: DockerBuild
        steps:
          - checkout: self
          - script: docker build -t $(imageRepository):$(imageTag) .
            displayName: "Docker build"
          - script: |
              docker run -d --name croissant-api-test -p 8080:8080 $(imageRepository):$(imageTag)
              sleep 5
              curl --fail http://localhost:8080/health
              docker rm -f croissant-api-test
            displayName: "Smoke test local du conteneur"

  - stage: Push_ACR
    displayName: "Push vers Azure Container Registry"
    dependsOn: Build_Image
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: DockerPush
        steps:
          - checkout: self
          - task: Docker@2
            displayName: "Build and push ACR"
            inputs:
              command: buildAndPush
              repository: $(imageRepository)
              dockerfile: Dockerfile
              containerRegistry: sc-acr-croissant
              tags: |
                $(imageTag)

  - stage: Deploy_Dev
    displayName: "Déploiement dev"
    dependsOn: Push_ACR
    jobs:
      - deployment: DeployDev
        environment: croissant-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebAppContainer@1
                  displayName: "Déployer dev"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    appName: $(devAppName)
                    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)

                - script: curl --fail https://$(devAppName).azurewebsites.net/health
                  displayName: "Smoke test dev"

  - stage: Deploy_Staging
    displayName: "Déploiement staging slot"
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        environment: croissant-staging
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebAppContainer@1
                  displayName: "Déployer sur slot staging"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    appName: $(prodAppName)
                    deployToSlotOrASE: true
                    resourceGroupName: $(resourceGroupName)
                    slotName: $(stagingSlotName)
                    containers: $(acrLoginServer)/$(imageRepository):$(imageTag)

                - script: curl --fail https://$(prodAppName)-$(stagingSlotName).azurewebsites.net/health
                  displayName: "Smoke test staging"

  - stage: Promote_Production
    displayName: "Promotion production"
    dependsOn: Deploy_Staging
    jobs:
      - deployment: SwapProduction
        environment: croissant-production
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureAppServiceManage@0
                  displayName: "Swap staging vers production"
                  inputs:
                    azureSubscription: sc-azure-croissant
                    Action: "Swap Slots"
                    WebAppName: $(prodAppName)
                    ResourceGroupName: $(resourceGroupName)
                    SourceSlot: $(stagingSlotName)
                    SwapWithProduction: true

                - script: curl --fail https://$(prodAppName).azurewebsites.net/health
                  displayName: "Smoke test production"
```

## Lecture du pipeline

```text
Test
   vérifie le code

Build_Image
   construit l’image et vérifie qu’elle démarre

Push_ACR
   publie l’image dans Azure Container Registry

Deploy_Dev
   déploie automatiquement en dev

Deploy_Staging
   déploie la nouvelle image sur le slot staging

Promote_Production
   swap staging vers production après protection de l’environnement
```

## Condition sur main

```yaml
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
```

Cette condition évite de pousser une image dans ACR depuis une pull request ou une branche de travail.

```text
pull request → tests + docker build
main → tests + docker build + push + déploiement
```

## Protection de la production

La protection n’est pas écrite directement dans ce YAML. Elle se configure sur l’environnement Azure DevOps `croissant-production`.

Exemples :

```text
approbation manuelle
branch control main only
exclusive lock
```

Le YAML demande le déploiement. L’environnement contrôle le passage.

## Rollback

Si la production pose problème après le swap :

```text
production : nouvelle version
staging    : ancienne version
```

Rollback rapide :

```text
refaire un swap staging → production
```

Ou déployer explicitement un ancien tag :

```text
croissant-api:127
```

Le fait de taguer les images rend ce rollback possible.

## Chaîne finale

```text
GitHub = source du code
Azure Pipelines = automatisation
Docker = format de livraison
ACR = stockage des images
App Service = exécution
Deployment slots = réduction du risque
Approvals = contrôle production
Key Vault = secrets
Bicep = infrastructure reproductible
```
---

## À pratiquer maintenant — Exercice 8 : lire le pipeline complet end-to-end

Terminez par l’exercice de synthèse :

- Énoncé : `exercices/08_pipeline_end_to_end.md`
- Corrigé : `corriges/08_pipeline_end_to_end_corrige.md`
- Pipeline complet : `demos/pipelines/04-full-docker-first.yml`

À la fin, vous devez pouvoir expliquer oralement le chemin complet :

```text
push GitHub
Azure Pipelines
npm test
docker build
docker push vers ACR
déploiement staging
smoke test
approbation production
swap
rollback possible
```

Cet exercice sert de récapitulatif final du cours.
