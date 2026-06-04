# Exercices

## Exercice 1 — Reconstituer la chaîne CI/CD

Remettre les étapes dans l’ordre :

```text
Déploiement en production
Tests automatisés
Commit
Artefact
Pull request
Déploiement staging
Build
```

## Exercice 2 — CI ou CD

Classer les actions suivantes dans CI ou CD :

| Action | CI ou CD |
|---|---|
| lancer les tests unitaires | |
| déployer sur App Service | |
| publier un artefact | |
| faire un smoke test après déploiement | |
| installer les dépendances | |
| attendre une approbation production | |

## Exercice 3 — Identifier les environnements

Associer chaque situation à un environnement : local, dev, staging ou production.

1. Un développeur teste une route sur sa machine.
2. L’équipe vérifie rapidement la dernière version intégrée.
3. Le product owner valide une version avant mise en ligne.
4. Les utilisateurs réels utilisent l’application.

## Exercice 4 — Écrire un premier pipeline

Créer un fichier `azure-pipelines.yml` qui :

```text
démarre sur main
utilise ubuntu-latest
installe Node.js 20
exécute npm ci
exécute npm test
```

## Exercice 5 — Ajouter un artefact

Compléter le pipeline précédent pour publier un artefact nommé :

```text
croissant-api
```

L’artefact doit contenir :

```text
package.json
package-lock.json
src/
```

## Exercice 6 — Ajouter un stage de déploiement Dev

Créer un stage `Deploy_Dev` qui dépend de `Build`, télécharge l’artefact et affiche :

```text
Déploiement Dev
```

## Exercice 7 — Variables et secrets

Classer les valeurs suivantes en variable simple ou secret :

| Valeur | Variable ou secret |
|---|---|
| nom de l’App Service | |
| chaîne de connexion SQL | |
| nom du Resource Group | |
| clé API externe | |
| nom de l’environnement | |
| token d’accès | |

## Exercice 8 — Production protégée

Compléter la liste des protections utiles pour un environnement production :

```text
approbation manuelle
...
...
...
```

## Exercice 9 — Slots et rollback

Expliquer ce qui se passe dans ce scénario :

```text
production = v1
staging = v2
swap staging → production
```

Puis expliquer comment revenir à `v1`.

## Exercice 10 — Lire un pipeline

Dans le pipeline complet du chapitre 12, identifier :

```text
le stage qui produit l’artefact
le stage qui déploie en Dev
le stage qui déploie sur le slot staging
le step qui effectue le swap
les endroits où un smoke test est exécuté
```
