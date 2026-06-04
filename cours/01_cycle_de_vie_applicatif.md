# 1. Le cycle de vie applicatif

Une application ne se limite pas au code écrit par les développeurs. Elle possède un cycle de vie complet : elle est conçue, développée, testée, validée, déployée, surveillée puis corrigée au fil du temps.

Dans une équipe, ce cycle doit être organisé. Si chaque personne construit, teste et déploie à sa manière, le projet devient vite difficile à contrôler. Le rôle d’une démarche DevOps est de rendre ce cycle plus fiable, plus automatisé et plus traçable.

## Du code à la production

Le chemin classique d’une modification ressemble à ceci :

```text
une demande métier
  ↓
une branche Git
  ↓
du code
  ↓
une pull request
  ↓
des validations automatiques
  ↓
un artefact
  ↓
un déploiement
  ↓
une version en production
```

Chaque étape ajoute un niveau de confiance.

Le code seul ne suffit pas. Il faut pouvoir répondre à des questions très concrètes :

```text
Qui a modifié cette fonctionnalité ?
Quels tests ont été exécutés ?
Quelle version est actuellement en production ?
Comment revenir à la version précédente ?
Où sont stockés les secrets ?
Qui a validé le passage en production ?
```

Un bon pipeline CI/CD permet de répondre à ces questions.

## Intégration continue

L’intégration continue, ou **CI** pour *Continuous Integration*, consiste à vérifier automatiquement le code dès qu’il est proposé dans le repository.

Elle répond à la question :

> Est-ce que le code peut être intégré sans casser l’application ?

Une CI classique exécute plusieurs étapes :

```text
récupérer le code
  ↓
installer les dépendances
  ↓
compiler ou préparer l’application
  ↓
lancer les tests
  ↓
publier les résultats
  ↓
produire un artefact
```

La CI détecte les problèmes tôt. Plus un bug est découvert tard, plus il coûte cher à corriger.

## Déploiement continu

Le déploiement continu, ou **CD** pour *Continuous Delivery* ou *Continuous Deployment*, prend le relais après la CI.

Il répond à la question :

> Comment mettre une version validée dans le bon environnement ?

Un CD classique ressemble à ceci :

```text
prendre l’artefact validé
  ↓
choisir un environnement cible
  ↓
appliquer la configuration de cet environnement
  ↓
déployer
  ↓
vérifier que l’application répond
  ↓
promouvoir vers l’environnement suivant
```

La différence entre les deux sens de CD est importante :

| Terme | Sens |
|---|---|
| Continuous Delivery | la version est prête à être livrée, mais une validation humaine peut être demandée |
| Continuous Deployment | la version est déployée automatiquement jusqu’en production |

Dans beaucoup d’entreprises, le déploiement en production reste protégé par une approbation humaine.

## Environnements

Une application passe généralement par plusieurs environnements avant d’arriver aux utilisateurs réels.

```text
local → dev → test/staging → production
```

| Environnement | Rôle |
|---|---|
| local | machine du développeur |
| dev | intégration rapide des changements |
| test / staging | validation proche de la production |
| production | environnement utilisé par les vrais utilisateurs |

Un environnement n’est pas seulement une URL. C’est un ensemble de ressources et de paramètres :

```text
application
base de données
variables de configuration
secrets
logs
monitoring
permissions
règles de déploiement
```

La règle importante est la suivante :

> On évite de changer le code entre les environnements. On change la configuration.

Exemple :

| Élément | Dev | Production |
|---|---|---|
| URL API | `https://api-dev.example.com` | `https://api.example.com` |
| Base de données | `croissant-dev-db` | `croissant-prod-db` |
| Logs | détaillés | contrôlés |
| Secrets | secrets de test | secrets réels |

## Artefact

Un artefact est le résultat exploitable d’un build.

Exemples :

```text
un fichier .zip
une image Docker
un package NuGet
un package npm
un fichier .jar
un dossier dist/
```

La pratique recommandée est souvent résumée ainsi :

> Build once, deploy everywhere.

Cela signifie que l’application est construite une seule fois, puis que le même artefact est déployé dans les différents environnements.

On évite ce scénario :

```text
build spécifique pour dev
build spécifique pour test
build spécifique pour prod
```

On préfère :

```text
un seul build
  ↓
un seul artefact
  ↓
déploiement en dev
  ↓
déploiement en staging
  ↓
déploiement en production
```

Cette approche réduit les écarts entre ce qui a été testé et ce qui est réellement mis en production.
