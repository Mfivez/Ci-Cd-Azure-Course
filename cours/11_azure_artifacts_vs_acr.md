# Chapitre 11 — Azure Artifacts vs Azure Container Registry

Azure Artifacts et Azure Container Registry sont deux services de stockage, mais ils ne stockent pas le même type de choses.

## Azure Container Registry

Azure Container Registry stocke des images Docker.

Exemples :

```text
croissant-api:128
frontend-web:20260605.1
worker-import:1.4.0
```

Utilisation :

```text
docker build
   ↓
docker push
   ↓
ACR
   ↓
Azure App Service / Container Apps / AKS
```

ACR est le bon choix pour les conteneurs.

## Azure Artifacts

Azure Artifacts stocke des packages applicatifs.

Exemples :

```text
npm
NuGet
Maven
Python
Cargo
Universal Packages
```

Utilisation :

```text
librairie interne
CLI interne
SDK partagé
composant commun
```

Exemple npm :

```text
@company/croissant-cli
@company/ui-components
```

Exemple NuGet :

```text
Company.Croissant.Security
Company.Croissant.Logging
```

## Différence simple

| Besoin | Service |
|---|---|
| stocker une image Docker | Azure Container Registry |
| stocker une librairie npm privée | Azure Artifacts |
| stocker un package NuGet privé | Azure Artifacts |
| déployer une image sur App Service | Azure Container Registry |
| partager une CLI interne | Azure Artifacts |
| centraliser des dépendances publiques npm/NuGet | Azure Artifacts avec upstream sources |

## Packages publics et upstream sources

Azure Artifacts peut aussi servir d’intermédiaire vers des registres publics.

Exemple Angular :

```text
Projet Angular
   ↓
Azure Artifacts feed
   ↓
npmjs.com
```

Avec des upstream sources, un feed Azure Artifacts peut récupérer des packages publics et les conserver dans le feed.

Intérêts :

```text
centraliser les dépendances
contrôler les sources autorisées
mettre en cache certains packages
réduire la dépendance directe aux registres publics
avoir un point de configuration unique pour l’équipe
```

## Exemple avec une CLI interne

Une équipe crée une CLI :

```text
croissant-cli
```

Si cette CLI est distribuée comme package npm :

```bash
npm install -g @company/croissant-cli
```

Azure Artifacts est adapté.

Si cette CLI est distribuée comme image Docker :

```bash
docker run company/croissant-cli:1.0.0
```

Un registry d’images est adapté.

## Dans le fil rouge Docker-first

Pour Croissant API :

```text
l’artefact de livraison = image Docker
le stockage = Azure Container Registry
```

Azure Artifacts peut être présenté comme un service complémentaire pour les packages, mais il n’est pas le registry principal de l’image Docker.
