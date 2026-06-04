# J3 — Démo guidée — Déployer vers Dev puis Staging

## Objectif

Prendre l’artefact produit par la CI et le déployer vers deux environnements : Dev puis Staging.

## Préparation

Idéalement :

- un pipeline CI avec artefact `drop` ;
- deux App Services : `croissant-web-dev` et `croissant-web-staging` ;
- deux Azure DevOps Environments : `croissant-dev`, `croissant-staging` ;
- une Service Connection Azure.

Si Azure n’est pas disponible, remplacer les tâches de déploiement par des `echo`.

## Étape 1 — Montrer le point de départ

```text
CI réussie
  ↓
Artefact drop/app.zip disponible
```

À dire :

> Aujourd’hui, on ne reconstruit pas. On récupère ce qui a été produit.

## Étape 2 — Créer les environments Azure DevOps

Navigation :

```text
Pipelines → Environments → New environment
```

Créer :

```text
croissant-dev
croissant-staging
```

Expliquer :

- historique des déploiements ;
- visibilité ;
- approvals plus tard.

## Étape 3 — Ajouter un stage Deploy_Dev

```yaml
- stage: Deploy_Dev
  dependsOn: CI
  jobs:
    - deployment: DeployDev
      environment: croissant-dev
      strategy:
        runOnce:
          deploy:
            steps:
              - download: current
                artifact: drop

              - script: echo "Déploiement de $(Pipeline.Workspace)/drop/app.zip en Dev"
```

## Étape 4 — Remplacer echo par AzureWebApp si possible

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer App Service Dev'
  inputs:
    azureSubscription: 'Azure-Dev-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-dev'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## Étape 5 — Ajouter un smoke test Dev

```yaml
- script: curl -f https://croissant-web-dev.azurewebsites.net/health
  displayName: 'Smoke test Dev'
```

Expliquer :

> On ne veut pas seulement que le déploiement termine. On veut que l’application réponde.

## Étape 6 — Ajouter Deploy_Staging après Dev

```yaml
- stage: Deploy_Staging
  dependsOn: Deploy_Dev
  jobs:
    - deployment: DeployStaging
      environment: croissant-staging
      strategy:
        runOnce:
          deploy:
            steps:
              - download: current
                artifact: drop

              - script: echo "Déploiement en Staging"

              - script: echo "Smoke test staging"
```

## Étape 7 — Montrer l’ordre d’exécution

Dans l’interface pipeline, montrer :

```text
CI → Deploy_Dev → Deploy_Staging
```

## Étape 8 — Montrer l’historique dans Environments

Navigation :

```text
Pipelines → Environments → croissant-dev
```

Montrer :

- date du déploiement ;
- pipeline ;
- commit ;
- statut.

## Étape 9 — Conclusion

Phrase :

> Nous avons maintenant une chaîne de promotion jusqu’à Staging. Demain, on protège la production et on prépare le rollback.
