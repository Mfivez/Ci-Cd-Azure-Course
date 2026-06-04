# J3 — Cours — CD et environnements Azure

## 1. Rappel : on part de l’artefact

À la fin de la CI, on obtient :

```text
Artefact drop
  └── app.zip
```

Le CD démarre ici.

Phrase importante :

> Le CD ne doit pas reconstruire une version différente. Il doit déployer la version validée.

## 2. Objectif du CD

Le CD répond à la question :

> Comment livrer cette version dans un environnement ?

Étapes classiques :

```text
récupérer l’artefact
  ↓
choisir l’environnement
  ↓
charger la configuration
  ↓
se connecter à la cible
  ↓
déployer
  ↓
vérifier
```

## 3. Continuous Delivery vs Continuous Deployment

| Terme | Explication |
|---|---|
| Continuous Delivery | on automatise jusqu’à rendre la version prête, avec validation humaine possible |
| Continuous Deployment | la version va automatiquement jusqu’à la production |

Exemple Delivery :

```text
CI OK → Dev automatique → Staging automatique → Production après approbation
```

Exemple Deployment :

```text
CI OK → Dev → Staging → Production sans intervention humaine
```

Pour une première approche, garder plutôt :

```text
Production = validation humaine
```

## 4. Environnements

Un environnement est un endroit où l’application tourne.

```text
local → dev → test → staging → production
```

| Environnement | Rôle |
|---|---|
| local | machine développeur |
| dev | validation rapide |
| test / QA | validation fonctionnelle |
| staging / preprod | proche production |
| production | vrais utilisateurs |

## 5. Le code ne change pas, la configuration change

Même artefact :

```text
app.zip
```

Configurations différentes :

| Élément | Dev | Staging | Prod |
|---|---|---|---|
| ENVIRONMENT_NAME | dev | staging | production |
| Base de données | db-dev | db-staging | db-prod |
| Logs | détaillés | proches prod | contrôlés |
| Secrets | test | préprod | réels |

Phrase clé :

> On ne modifie pas le code pour passer de staging à production. On change la configuration.

## 6. Azure App Service comme cible simple

Pour un cours débutant, Azure App Service est une bonne cible car :

- il héberge une application web ;
- il évite de gérer les serveurs ;
- il s’intègre bien avec Azure Pipelines ;
- il permet ensuite d’expliquer les slots.

Concepts minimaux :

| Concept Azure | Explication simple |
|---|---|
| Resource Group | dossier logique de ressources Azure |
| App Service Plan | capacité d’hébergement |
| App Service | application web hébergée |
| Application Settings | variables de configuration de l’app |

## 7. Azure DevOps Environments

Dans Azure DevOps, un Environment représente une cible logique de déploiement.

Exemples :

```text
croissant-dev
croissant-staging
croissant-production
```

Intérêt :

- historique de déploiements ;
- approvals et checks ;
- séparation logique des environnements ;
- meilleure visibilité.

## 8. Deployment job

Pour cibler un environment Azure DevOps, on utilise souvent un `deployment` job.

```yaml
- deployment: DeployDev
  environment: croissant-dev
  strategy:
    runOnce:
      deploy:
        steps:
          - script: echo "Deploy Dev"
```

Différence simple :

| Job classique | Deployment job |
|---|---|
| exécute des tâches | exécute un déploiement vers un environment |
| pas forcément d’historique d’environnement | historique lié à l’environment |

## 9. Service Connection

Azure DevOps doit avoir le droit de déployer sur Azure.

Une Service Connection sert à ça.

Phrase simple :

> C’est le badge d’accès du pipeline vers Azure.

Bonnes pratiques simples :

- ne pas utiliser un compte personnel ;
- limiter les droits ;
- ne pas donner accès à tous les pipelines si ce n’est pas nécessaire ;
- utiliser une connexion différente pour dev/prod si besoin.

## 10. Variables par environnement

Exemple :

```yaml
variables:
  environmentName: 'dev'
  appName: 'croissant-web-dev'
```

Mais pour plusieurs environnements, préférer :

- Variable Groups ;
- variables d’environnement Azure DevOps ;
- settings Azure App Service.

Pour le jour 3, rester simple :

```text
Dev utilise appName = croissant-web-dev
Staging utilise appName = croissant-web-staging
```

## 11. Pipeline Dev puis Staging

Schéma :

```text
CI
  ↓
Deploy Dev
  ↓
Smoke test Dev
  ↓
Deploy Staging
  ↓
Smoke test Staging
```

YAML simplifié :

```yaml
stages:
  - stage: CI
    jobs:
      - job: Build
        steps:
          - script: echo "Build + tests"

  - stage: Deploy_Dev
    dependsOn: CI
    jobs:
      - deployment: DeployDev
        environment: croissant-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Déployer en Dev"

  - stage: Deploy_Staging
    dependsOn: Deploy_Dev
    jobs:
      - deployment: DeployStaging
        environment: croissant-staging
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Déployer en Staging"
```

## 12. Télécharger l’artefact dans le stage CD

Dans un stage de déploiement :

```yaml
- download: current
  artifact: drop
```

Ensuite, le chemin peut être :

```text
$(Pipeline.Workspace)/drop/app.zip
```

## 13. Déploiement Azure App Service — exemple

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer sur App Service Dev'
  inputs:
    azureSubscription: 'Azure-Dev-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-dev'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

Pour staging :

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer sur App Service Staging'
  inputs:
    azureSubscription: 'Azure-Staging-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-staging'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## 14. Smoke tests

Un smoke test vérifie rapidement que l’application répond.

Exemple :

```yaml
- script: |
    curl -f https://croissant-web-dev.azurewebsites.net/health
  displayName: 'Smoke test Dev'
```

Le `-f` permet de faire échouer la commande si le statut HTTP indique une erreur.

## 15. Pipeline CD simplifié complet

```yaml
stages:
  - stage: Deploy_Dev
    jobs:
      - deployment: DeployDev
        environment: croissant-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop

                - task: AzureWebApp@1
                  inputs:
                    azureSubscription: 'Azure-Dev-SC'
                    appType: 'webAppLinux'
                    appName: 'croissant-web-dev'
                    package: '$(Pipeline.Workspace)/drop/app.zip'

                - script: curl -f https://croissant-web-dev.azurewebsites.net/health
                  displayName: 'Smoke test Dev'
```

## 16. Résumé du jour

À retenir :

```text
CD = déployer un artefact validé
Environnement = cible logique de déploiement
Service Connection = identité du pipeline vers Azure
Variable = configuration non sensible
Smoke test = vérification rapide après déploiement
Dev puis Staging = progression contrôlée
```
