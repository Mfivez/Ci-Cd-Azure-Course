# 9. Variables, secrets et Key Vault

Un pipeline a besoin de configuration.

Certaines valeurs ne sont pas sensibles :

```text
nom d’une application
nom d’un resource group
nom d’un environnement
URL publique
```

D’autres valeurs sont sensibles :

```text
mot de passe
clé API
token
chaîne de connexion
certificat
```

Il faut distinguer **variables** et **secrets**.

## Variables non sensibles

Une variable non sensible peut être écrite dans le YAML si elle ne pose pas de risque.

```yaml
variables:
  appName: "app-croissant-dev"
  environmentName: "dev"
```

Utilisation :

```yaml
- script: echo "Déploiement de $(appName)"
```

## Secrets

Un secret ne doit jamais être écrit dans le code ni dans le YAML.

Mauvais exemple :

```yaml
variables:
  databasePassword: "SuperPassword123"
```

Bon principe :

```text
le YAML référence le secret
le secret est stocké dans un espace sécurisé
la valeur est masquée dans les logs
```

## Variable Groups

Dans Azure DevOps, les Variable Groups se trouvent dans :

```text
Pipelines → Library → Variable groups
```

Un variable group permet de centraliser des variables utilisées par plusieurs pipelines.

Exemple :

```text
croissant-dev-vars
croissant-staging-vars
croissant-prod-vars
```

On peut y stocker :

```text
APP_NAME
APP_HOSTNAME
RESOURCE_GROUP
DATABASE_URL
```

Les variables sensibles doivent être marquées comme secrètes.

## Utiliser un Variable Group dans YAML

```yaml
variables:
  - group: croissant-dev-vars
```

Puis :

```yaml
- script: echo "Application : $(APP_NAME)"
```

## Variables par environnement

Pour éviter de mélanger dev, staging et production, on peut utiliser des groupes séparés.

```yaml
variables:
  - group: croissant-staging-vars
```

Puis le stage staging utilise les valeurs staging.

La production peut utiliser un autre groupe :

```yaml
variables:
  - group: croissant-prod-vars
```

## Azure Key Vault

Azure Key Vault est le coffre-fort Azure pour les secrets.

Il sert à stocker :

```text
secrets applicatifs
certificats
clés cryptographiques
chaînes de connexion
```

Dans une approche plus propre, Azure DevOps ne stocke pas directement tous les secrets. Il les lit depuis Key Vault.

## Lier un Variable Group à Key Vault

Un variable group peut être lié à un Azure Key Vault.

Le pipeline accède alors aux secrets sans les écrire dans le YAML.

Exemple conceptuel :

```yaml
variables:
  - group: croissant-keyvault-secrets
```

Puis :

```yaml
- script: echo "Le secret existe mais sa valeur ne doit pas être affichée"
```

## Règles importantes

```text
ne jamais committer un secret
ne jamais afficher un secret avec echo
ne jamais partager un token personnel
utiliser des secrets différents par environnement
limiter les droits des Service Connections
supprimer et renouveler un secret exposé
```

## Exemple avec Croissant API

L’application peut lire une variable d’environnement :

```text
ENVIRONMENT_NAME=staging
```

Elle peut aussi lire une chaîne de connexion :

```text
DATABASE_CONNECTION_STRING
```

La première valeur peut être une variable simple.
La deuxième doit être un secret.

## Configuration dans App Service

Azure App Service possède des **Application Settings**.

Ces settings deviennent des variables d’environnement pour l’application.

Exemples :

```text
ENVIRONMENT_NAME=Production
LOG_LEVEL=Warning
DATABASE_CONNECTION_STRING=secret
```

Le pipeline peut déployer l’application, mais la configuration de l’environnement doit rester séparée du code.
