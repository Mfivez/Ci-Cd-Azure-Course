# Chapitre 12 — Approbations, checks et production

Un pipeline peut déployer automatiquement en dev. Pour la production, on ajoute souvent un contrôle humain ou automatique.

```text
dev : automatique
staging : automatique ou semi-automatique
production : protégée
```

Azure DevOps permet de protéger un environnement avec des approvals et checks.

## Environments dans Azure DevOps

Un environnement Azure DevOps sert à tracer et contrôler les déploiements.

Exemples :

```text
croissant-dev
croissant-staging
croissant-production
```

Dans le YAML :

```yaml
- deployment: DeployProduction
  environment: croissant-production
```

Cet environnement peut avoir des règles.

## Approbation manuelle

Une approbation manuelle bloque le pipeline jusqu’à validation.

```text
Deploy_Production démarre
   ↓
Azure DevOps demande une approbation
   ↓
un approver valide
   ↓
le déploiement continue
```

Cela crée une trace :

```text
qui a approuvé
quand
pour quel run
vers quel environnement
```

## Branch control

Un check de branche peut interdire la production depuis une branche autre que `main`.

```text
main → autorisé
feature/test → bloqué
```

Ce check évite les déploiements accidentels.

## Exclusive lock

Un exclusive lock évite deux déploiements simultanés sur le même environnement.

```text
pipeline A déploie staging
pipeline B attend
```

C’est utile pour éviter les collisions.

## Deployment job complet

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
              - task: AzureWebAppContainer@1
                inputs:
                  azureSubscription: sc-azure-croissant
                  appName: croissant-api-prod
                  containers: $(acrLoginServer)/$(imageRepository):$(imageTag)
```

Le YAML demande le déploiement.

L’environnement décide si le déploiement doit attendre une approbation.

## Approvals dans le portail

Configuration typique :

```text
Azure DevOps
   ↓
Pipelines
   ↓
Environments
   ↓
croissant-production
   ↓
Approvals and checks
```

Checks possibles :

```text
approbation manuelle
branch control
business hours
exclusive lock
requête REST externe
Azure Monitor alerts
```

## Production ne veut pas dire tout automatique

Continuous Deployment signifie que tout peut aller automatiquement jusqu’en production.

Continuous Delivery signifie qu’une version est prête, mais une validation peut rester nécessaire.

Dans beaucoup d’équipes :

```text
CI automatique
CD dev automatique
CD staging automatique
CD production avec approbation
```

Ce modèle est déjà très professionnel.
