# Chapitre 1 — Du conteneur local à la livraison automatisée

Une application peut très bien fonctionner sur une machine locale et échouer au moment du déploiement. Les causes sont souvent les mêmes : version différente de Node.js, dépendance oubliée, variable d’environnement absente, commande de démarrage différente ou configuration non documentée.

Docker réduit ce problème en emballant l’application et son environnement d’exécution dans une image.

```text
Code source
   ↓
Dockerfile
   ↓
Image Docker
   ↓
Conteneur
```

L’image Docker devient une unité de livraison. Elle contient ce qu’il faut pour démarrer l’application de façon prévisible.

Dans ce cours, le fil conducteur est une petite API appelée **Croissant API**.

```text
Croissant API
   ├── une route /
   ├── une route /health
   ├── une route /version
   └── une route /products
```

L’application est volontairement simple. Le sujet n’est pas de développer une API complexe, mais de suivre son trajet complet : du code GitHub jusqu’à une application déployée sur Azure.

## Le chemin complet

Le trajet Docker-first est le suivant :

```text
GitHub
   ↓
Azure Pipelines
   ↓
Tests automatisés
   ↓
Build de l’image Docker
   ↓
Push de l’image dans Azure Container Registry
   ↓
Déploiement de l’image sur Azure App Service
   ↓
Validation en staging
   ↓
Bascule en production
```

Cette chaîne contient trois familles d’outils.

| Élément | Rôle |
|---|---|
| GitHub | stocke le code source |
| Azure DevOps / Azure Pipelines | automatise les tests, le build et le déploiement |
| Azure | héberge les ressources réelles : registry, application, configuration, logs |

Azure DevOps ne fait pas tourner l’application finale. Il orchestre le processus. L’application tourne dans Azure.

## CI et CD avec Docker

La CI vérifie que le code est intégrable.

```text
push ou pull request
   ↓
installer / vérifier
   ↓
lancer les tests
   ↓
construire l’image Docker
```

Le CD déploie une version validée.

```text
image Docker validée
   ↓
registry
   ↓
environnement dev ou staging
   ↓
production
```

Avec Docker, l’artefact principal n’est plus un `.zip` ou un dossier `dist/`. L’artefact principal devient l’image Docker.

Exemple :

```text
croissant-api:42
croissant-api:1.0.0
croissant-api:main-20260605
```

Une image Docker versionnée permet de répondre clairement à la question :

> Quelle version exacte tourne dans cet environnement ?

## Le principe “build once, deploy many”

Une erreur fréquente consiste à reconstruire l’application pour chaque environnement.

```text
build image pour dev
build image pour staging
build image pour prod
```

Ce modèle est risqué, car la production ne reçoit pas forcément exactement ce qui a été testé.

On préfère :

```text
une image Docker construite une fois
   ↓
déployée en dev
   ↓
déployée en staging
   ↓
déployée en production
```

Ce qui change entre les environnements n’est pas l’image. C’est la configuration.

Exemple :

| Élément | Dev | Production |
|---|---|---|
| Image Docker | `croissant-api:42` | `croissant-api:42` |
| `ENVIRONMENT_NAME` | `dev` | `production` |
| `LOG_LEVEL` | `debug` | `info` |
| URL publique | dev | prod |

La même image peut donc afficher ou utiliser une configuration différente selon l’environnement.

## Pourquoi garder Docker au centre du cours

Docker donne un support concret pour comprendre la CI/CD.

Sans Docker :

```text
Le pipeline produit quelque chose d’un peu abstrait : package, zip, build, dossier.
```

Avec Docker :

```text
Le pipeline produit une image que l’on peut lancer partout de la même manière.
```

Localement :

```bash
docker run -p 8080:8080 croissant-api:local
```

Dans Azure :

```text
Azure App Service lance cette même image depuis Azure Container Registry.
```

Le lien devient simple :

```text
Dockerfile = recette de construction
Image Docker = version livrable
Registry = entrepôt d’images
App Service = endroit où l’image tourne
Pipeline = automatisation du chemin
```
