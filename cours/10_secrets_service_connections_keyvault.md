# Chapitre 10 — Secrets, service connections et Key Vault

Un pipeline CD a besoin d’accéder à des ressources externes.

Exemples :

```text
pousser une image dans ACR
déployer sur App Service
lire des secrets applicatifs
modifier des settings Azure
```

Ces actions nécessitent des droits. Ces droits ne doivent pas être codés en dur dans le repository.

## Ce qu’il ne faut jamais committer

```text
mot de passe
clé API
token
connection string
fichier .env réel
clé privée
publish profile
PAT
```

Le repository doit contenir au maximum des exemples.

```text
.env.example
```

Pas :

```text
.env
```

## Service connection

Une service connection est une identité utilisée par Azure Pipelines pour accéder à un service.

Exemples :

| Service connection | Sert à |
|---|---|
| Docker Registry / ACR | pousser une image Docker |
| Azure Resource Manager | déployer dans Azure |
| GitHub | accéder à un repo GitHub |

Dans le YAML, on référence le nom de la service connection.

```yaml
containerRegistry: sc-acr-croissant
```

```yaml
azureSubscription: sc-azure-croissant
```

Le secret n’apparaît pas dans le YAML. Le YAML ne contient que le nom logique de la connexion.

## Principe du moindre privilège

La service connection ne doit avoir que les droits nécessaires.

Exemples :

```text
pousser dans ACR, pas administrer tout l’abonnement
déployer sur un Resource Group, pas gérer toutes les ressources Azure
lire des secrets précis, pas tout Key Vault
```

Plus les droits sont limités, plus l’impact d’une erreur est réduit.

## Variables secrètes

Dans Azure Pipelines, une variable peut être marquée comme secrète.

```text
Pipelines → Library → Variable Groups
```

Une variable secrète est masquée dans les logs.

```text
***
```

Mais il faut quand même éviter de l’afficher volontairement.

## Azure Key Vault

Azure Key Vault est le coffre-fort Azure pour les secrets.

On peut y stocker :

```text
mots de passe
connection strings
certificats
clés API
```

Un pipeline peut récupérer des secrets depuis Key Vault, ou un App Service peut lire ses secrets via des références Key Vault.

## Variable Group lié à Key Vault

Un Variable Group peut être lié à Key Vault.

```text
Azure Key Vault
   ↓
Variable Group Azure Pipelines
   ↓
Pipeline
```

Cela évite de copier manuellement les secrets dans Azure DevOps.

## Différence entre configuration et secret

| Valeur | Type | Où la mettre |
|---|---|---|
| nom de l’application | configuration | YAML ou Variable Group |
| nom du Resource Group | configuration | YAML ou Variable Group |
| `LOG_LEVEL=info` | configuration | App Settings |
| mot de passe DB | secret | Key Vault |
| clé API externe | secret | Key Vault |
| token de déploiement | secret | Service connection |

## Exemple de variable group

```yaml
variables:
  - group: vg-croissant-dev
```

Puis dans le pipeline :

```yaml
- script: echo "Déploiement vers $(APP_SERVICE_NAME)"
```

Si `APP_SERVICE_NAME` est non sensible, c’est correct.

Si `DATABASE_PASSWORD` est secret, ne jamais faire :

```yaml
- script: echo "$(DATABASE_PASSWORD)"
```

## Secrets et Docker

Ne pas injecter un secret dans l’image au moment du build.

Mauvais modèle :

```dockerfile
ENV DATABASE_PASSWORD=SuperSecret123
```

Bon modèle :

```text
l’image est générique
le secret est injecté au runtime par l’environnement
```

```text
Docker image
   ↓
App Service Application Settings / Key Vault
   ↓
conteneur démarré avec les secrets nécessaires
```

Une image Docker ne doit pas contenir de secret réel.
