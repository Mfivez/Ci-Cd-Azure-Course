# 10. Approbations, checks et production

La production est l’environnement le plus sensible.

Un déploiement en production peut impacter de vrais utilisateurs, des données réelles et l’image de l’entreprise.

Pour cette raison, le pipeline ne doit pas traiter la production comme un environnement ordinaire.

## Protection de la production

Un déploiement en production peut être protégé par :

```text
approbation manuelle
contrôle de branche
vérification d’alertes
verrouillage exclusif
restriction des permissions
historique des déploiements
```

Azure DevOps permet de configurer ces protections sur les **Environments**.

## Environnement production

Dans Azure DevOps :

```text
Pipelines → Environments → New environment
```

Nom possible :

```text
croissant-production
```

Un stage de pipeline peut cibler cet environnement :

```yaml
- stage: Deploy_Production
  displayName: "Déploiement Production"
  jobs:
    - deployment: DeployProduction
      environment: "croissant-production"
      strategy:
        runOnce:
          deploy:
            steps:
              - script: echo "Déploiement production"
```

## Approbation manuelle

Une approbation manuelle bloque le pipeline jusqu’à ce qu’une personne autorisée valide.

Flux :

```text
staging réussi
  ↓
pipeline demande validation production
  ↓
approbateur vérifie
  ↓
approbation
  ↓
déploiement production
```

L’approbation ajoute une trace :

```text
qui a approuvé
quand
pour quel déploiement
```

## Branch control

La production ne devrait pas accepter un déploiement depuis n’importe quelle branche.

Règle classique :

```text
seule main peut aller en production
```

Cela évite qu’une branche de fonctionnalité soit déployée accidentellement.

## Exclusive lock

Un verrou exclusif empêche deux déploiements simultanés sur le même environnement.

Sans verrou :

```text
pipeline A déploie
pipeline B déploie en même temps
résultat incertain
```

Avec verrou :

```text
pipeline A déploie
pipeline B attend
```

## Production dans le YAML

Exemple :

```yaml
- stage: Deploy_Production
  displayName: "Déploiement Production"
  dependsOn: Deploy_Staging
  jobs:
    - deployment: DeployProduction
      displayName: "Déployer en Production"
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
                displayName: "Déployer sur App Service Production"
                inputs:
                  azureSubscription: "$(azureServiceConnection)"
                  appType: "webAppLinux"
                  appName: "$(prodAppName)"
                  package: "$(Pipeline.Workspace)/croissant-api"
```

La protection n’est pas seulement dans le YAML. Elle se configure aussi sur l’environnement Azure DevOps.

## Vérification après production

Après le déploiement, il faut vérifier que l’application répond.

```yaml
- script: |
    curl --fail https://$(prodAppName).azurewebsites.net/health
  displayName: "Smoke test production"
```

Un smoke test ne remplace pas tous les tests fonctionnels. Il vérifie seulement que la version déployée est vivante.

## Responsabilité du passage en production

Un bon pipeline rend le déploiement reproductible.

Mais la décision de production peut rester humaine.

Avant d’approuver, on peut vérifier :

```text
la CI est verte
l’artefact est identifié
staging est validé
les tests importants sont passés
aucune alerte critique n’est active
un rollback est possible
```

La production n’est pas un simple bouton. C’est une étape contrôlée.
