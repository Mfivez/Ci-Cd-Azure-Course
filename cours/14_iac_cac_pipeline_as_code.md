# Chapitre 14 — Infrastructure as Code, Configuration as Code, Pipeline as Code

Les termes se ressemblent, mais ils ne désignent pas la même chose.

```text
Pipeline as Code
Configuration as Code
Infrastructure as Code
```

Ils ont un point commun : écrire dans des fichiers ce qui était souvent fait à la main dans une interface.

## Pipeline as Code

Pipeline as Code signifie que le pipeline est décrit dans un fichier.

Exemple :

```text
azure-pipelines.yml
```

Il décrit :

```text
triggers
stages
jobs
steps
tests
build Docker
push ACR
deploy App Service
```

Le pipeline est versionné avec le code.

```text
modification du pipeline
   ↓
pull request
   ↓
review
   ↓
historique Git
```

## Configuration as Code

Configuration as Code signifie que la configuration non sensible est décrite dans des fichiers ou dans des objets gérés.

Exemples :

```text
docker-compose.yml
variables YAML
Variable Groups
fichiers de templates
valeurs d’environnement documentées
```

Exemple :

```yaml
variables:
  imageRepository: croissant-api
  acrLoginServer: croissantregistrydemo.azurecr.io
```

Ou :

```yaml
services:
  api:
    environment:
      ENVIRONMENT_NAME: local
      LOG_LEVEL: debug
```

Configuration as Code ne veut pas dire committer les secrets.

```text
config non sensible : oui
secret réel : non
```

## Infrastructure as Code

Infrastructure as Code signifie que les ressources cloud sont décrites dans des fichiers.

Exemples de ressources :

```text
Resource Group
Azure Container Registry
App Service Plan
App Service
Deployment Slot
Key Vault
Application Insights
```

Outils possibles :

```text
Bicep
Terraform
ARM templates
Pulumi
```

Avec Bicep, on décrit l’état souhaité des ressources Azure.

Exemple simplifié :

```bicep
resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'plan-croissant-demo'
  location: resourceGroup().location
  sku: {
    name: 'B1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}
```

Le principe :

```text
au lieu de cliquer dans Azure Portal
on écrit l’infrastructure dans un fichier
```

## Comparaison

| Terme | Décrit quoi ? | Exemple |
|---|---|---|
| Pipeline as Code | la chaîne CI/CD | `azure-pipelines.yml` |
| Configuration as Code | les paramètres et valeurs non sensibles | `docker-compose.yml`, variables YAML |
| Infrastructure as Code | les ressources cloud | `main.bicep`, `main.tf` |

## Dans le fil rouge Croissant API

```text
Infrastructure as Code
   crée ACR, App Service, slots

Configuration as Code
   définit ENVIRONMENT_NAME, LOG_LEVEL, ports

Pipeline as Code
   automatise tests, docker build, docker push, déploiement
```

Les trois couches se complètent.

```text
Infrastructure = où l’application peut tourner
Configuration = comment elle se comporte
Pipeline = comment elle arrive jusque-là
```
---

## À pratiquer maintenant — Exercice 7 : distinguer IaC, CaC et Pipeline as Code

Avant de lire le pipeline complet, réalisez l’exercice :

- Énoncé : `exercices/07_iac_cac_pipeline_as_code.md`
- Corrigé : `corriges/07_iac_cac_pipeline_as_code_corrige.md`
- Exemple IaC : `demos/infra/main.bicep`

À la fin, vous devez savoir classer un fichier comme :

```text
Infrastructure as Code
Configuration as Code
Pipeline as Code
secret à ne pas versionner
```

Reprenez au chapitre 15 lorsque les trois notions sont bien séparées.
