# Glossaire CI/CD, Azure DevOps et environnements

## CI — Continuous Integration

La CI est l’automatisation qui vérifie le code dès qu’un changement est poussé.

Elle répond à la question :

> Est-ce que le code est intégrable sans casser le projet ?

Exemples d’étapes CI :

```text
restore dépendances
build
lint
tests unitaires
analyse qualité
publication des résultats
publication d’un artefact
```

## CD — Continuous Delivery / Continuous Deployment

Le CD prend une version validée par la CI et la fait progresser vers un ou plusieurs environnements.

Il répond à la question :

> Comment livrer cette version proprement ?

Différence utile :

| Terme | Sens |
|---|---|
| Continuous Delivery | prêt à déployer, souvent avec validation humaine |
| Continuous Deployment | déploiement automatique jusqu’en production |

## Pipeline

Un pipeline est une suite d’étapes automatisées.

```text
code → pipeline → vérifications → artefact → déploiement
```

## Trigger

Un trigger indique quand le pipeline démarre.

Exemples :

```yaml
trigger:
  - main
```

ou :

```yaml
pr:
  - main
```

## Stage

Un stage est une grande phase du pipeline.

Exemples :

```text
Build
Test
Deploy_Dev
Deploy_Staging
Deploy_Prod
```

## Job

Un job est une unité de travail exécutée sur un agent.

Un stage peut contenir plusieurs jobs.

## Step

Un step est une action précise dans un job.

Exemples :

```text
exécuter npm ci
exécuter npm test
archiver le build
publier l’artefact
```

## Agent

Un agent est la machine qui exécute le pipeline.

Deux grands types :

| Type | Explication |
|---|---|
| Microsoft-hosted | machine fournie automatiquement par Azure DevOps |
| Self-hosted | machine gérée par l’entreprise |

Pour débuter, utiliser `ubuntu-latest` suffit largement.

## Artefact

Un artefact est le résultat déployable de la CI.

Exemples :

```text
app.zip
build React
fichier .jar
package npm
image Docker
```

Phrase à retenir :

> En CI, on produit l’artefact. En CD, on déploie l’artefact.

## Build once, deploy everywhere

Principe : construire une seule fois, puis déployer le même artefact dans Dev, Staging et Prod.

Le code ne change pas entre les environnements. Seule la configuration change.

## Environnement

Un environnement est un endroit où l’application tourne.

Exemples :

```text
local
dev
test
staging
production
```

## Dev

Environnement de validation rapide. Il peut être instable.

## Test / QA

Environnement pour tester les fonctionnalités, souvent par l’équipe QA ou métier.

## Staging / Preprod

Environnement proche de la production.

Objectif : valider la version avant exposition aux vrais utilisateurs.

## Production

Environnement utilisé par les vrais utilisateurs.

Il doit être protégé.

## Variable

Une variable est une valeur de configuration non sensible.

Exemples :

```text
APP_NAME
RESOURCE_GROUP
ENVIRONMENT_NAME
```

## Secret

Un secret est une valeur sensible.

Exemples :

```text
mot de passe
token
clé API
chaîne de connexion
certificat
```

Règle :

> Un secret ne doit jamais être écrit dans Git ni en clair dans un YAML.

## Variable Group

Dans Azure DevOps, un Variable Group permet de centraliser des variables réutilisables entre plusieurs pipelines.

## Azure Key Vault

Service Azure qui stocke des secrets, certificats et clés.

Dans un premier cours, il suffit de retenir :

> Key Vault est le coffre-fort des secrets applicatifs.

## Service Connection

Une Service Connection est l’identité utilisée par Azure DevOps pour se connecter à un service externe, par exemple Azure.

Elle doit être limitée au strict nécessaire.

## Deployment Job

Dans Azure Pipelines, un deployment job permet de déployer vers un environnement et de garder un historique de déploiement.

## Approval

Une approval est une validation humaine avant une étape sensible.

Exemple :

```text
Avant la production, le Tech Lead ou le PO doit approuver.
```

## Check

Un check est une condition avant déploiement.

Exemples :

```text
branche autorisée
approbateur obligatoire
aucune alerte Azure Monitor active
un seul déploiement à la fois
```

## Smoke Test

Test très court lancé après déploiement pour vérifier que l’application répond.

Exemple :

```bash
curl https://mon-app.azurewebsites.net/health
```

## Blue/Green

Stratégie de déploiement avec deux versions :

```text
Blue  = version actuelle
Green = nouvelle version
```

Une fois Green validée, on bascule le trafic.

## Deployment Slot

Dans Azure App Service, un slot est un emplacement de déploiement parallèle.

Exemple :

```text
production
staging
```

On peut déployer sur `staging`, tester, puis faire un swap vers production.

## Swap

Échange entre deux slots Azure App Service.

```text
staging → production
```

## Rollback

Retour à une version précédente si la nouvelle version pose problème.

Avec des slots, le rollback peut être un swap inverse.

## Branch Policy

Règle qui protège une branche.

Exemples :

```text
interdire le push direct sur main
obliger une Pull Request
obliger un build réussi
obliger un reviewer
```

## Shift Left

Déplacer les contrôles qualité et sécurité le plus tôt possible dans le cycle de développement.

Exemples :

```text
tests au commit
analyse de dépendances
scan de secrets
lint
quality gate
```
