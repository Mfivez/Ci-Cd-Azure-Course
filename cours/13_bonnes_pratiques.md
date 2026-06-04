# 13. Bonnes pratiques

Un pipeline CI/CD doit être fiable, lisible et sécurisé.

Le but n’est pas seulement d’automatiser. Le but est d’automatiser proprement.

## Versionner le pipeline

Le fichier YAML doit être dans le repository.

```text
azure-pipelines.yml
```

Avantages :

```text
historique Git
review en pull request
rollback
traçabilité
cohérence avec le code
```

## Garder les branches courtes

Les branches longues compliquent l’intégration.

Préférer :

```text
petites branches
petites pull requests
feedback rapide
merge fréquent
```

## Protéger main

La branche `main` doit être protégée.

Règles recommandées :

```text
pas de push direct
pull request obligatoire
review obligatoire
build obligatoire
work item lié si le projet utilise Boards
```

## Faire échouer le pipeline en cas de problème

Un pipeline qui masque les erreurs n’est pas fiable.

Les commandes importantes doivent retourner une erreur si elles échouent.

Exemple :

```bash
curl --fail https://app.example.com/health
```

Sans `--fail`, certains problèmes HTTP peuvent passer inaperçus.

## Construire une seule fois

Éviter :

```text
rebuild pour dev
rebuild pour staging
rebuild pour prod
```

Préférer :

```text
un build
un artefact
plusieurs déploiements
```

## Séparer code et configuration

Le code doit rester le même entre les environnements.

La configuration change :

```text
nom de base de données
URL API
niveau de logs
secrets
feature flags
```

## Ne jamais committer un secret

Interdits :

```text
mot de passe dans le code
token dans le YAML
fichier .env commité
clé privée dans le repository
```

À utiliser :

```text
variables secrètes
Variable Groups
Azure Key Vault
Service Connections limitées
```

## Limiter les permissions

Une Service Connection ne doit pas avoir plus de droits que nécessaire.

Principe :

```text
le pipeline dev ne doit pas pouvoir déployer en production
un pipeline inconnu ne doit pas accéder aux secrets production
les admins production doivent être peu nombreux
```

## Utiliser les environnements Azure DevOps

Les environnements apportent :

```text
historique de déploiement
approbations
checks
contrôle de branche
verrouillage exclusif
```

La production doit être un environnement protégé.

## Prévoir le rollback

Un rollback ne doit pas être improvisé pendant un incident.

Il doit être pensé avant.

Avec App Service slots :

```text
swap vers production
si problème : swap inverse
```

## Ajouter du monitoring

Un déploiement réussi techniquement ne suffit pas.

Il faut surveiller :

```text
taux d’erreur
latence
logs applicatifs
alertes Azure Monitor
résultat des smoke tests
```

## Garder le YAML lisible

Un pipeline trop long devient difficile à maintenir.

Bonnes pratiques :

```text
noms clairs pour les stages
noms clairs pour les steps
variables explicites
templates pour les blocs répétés
commentaires seulement quand ils aident vraiment
```

## Améliorations possibles

Une fois la base stable, on peut ajouter :

```text
quality gate SonarCloud
scan des dépendances
scan des secrets
scan d’images Docker
notifications Teams
métriques DORA
templates partagés
Infrastructure as Code
```

Ces améliorations renforcent la chaîne sans changer son principe de base :

```text
code → CI → artefact → CD → environnements → production contrôlée
```
