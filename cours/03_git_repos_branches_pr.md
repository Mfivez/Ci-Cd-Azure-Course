# 3. Git, branches et pull requests

Le pipeline CI/CD commence avec un repository Git propre.

Pour Croissant API, le code est stocké dans un repository Azure Repos. Les développeurs ne travaillent pas directement sur la branche principale. Ils créent des branches courtes, proposent leurs changements via pull request, puis la CI vérifie automatiquement le résultat.

## Branche principale

La branche principale s’appelle généralement `main`.

Elle représente la version stable du code.

```text
main
```

Une règle saine consiste à protéger cette branche :

```text
pas de push direct sur main
passage obligatoire par pull request
build obligatoire avant merge
revue de code obligatoire
```

## Branches de travail

Une branche de travail permet de développer sans casser `main`.

Exemples de noms :

```text
feature/add-health-endpoint
feature/123-add-croissant-list
bugfix/fix-health-route
hotfix/fix-production-crash
```

Une branche doit rester courte. Plus une branche vit longtemps, plus elle risque de diverger de `main`.

## Commit

Un commit représente une modification enregistrée dans l’historique Git.

Un bon message de commit explique ce qui change.

Exemples :

```text
feat: add health endpoint
fix: return 200 on health check
test: add health endpoint test
ci: add node pipeline
```

Les messages structurés facilitent la génération de notes de version et la compréhension de l’historique.

## Pull request

Une pull request est une demande d’intégration d’une branche dans une autre.

Dans Azure Repos, une PR permet de :

```text
relire le code
commenter les changements
lier un work item
exécuter un pipeline de validation
bloquer le merge si la CI échoue
conserver une trace de validation
```

Flux classique :

```text
créer une branche
  ↓
modifier le code
  ↓
pousser la branche
  ↓
ouvrir une pull request
  ↓
CI automatique
  ↓
review
  ↓
merge vers main
```

## Policies de branche

Les branch policies sont des règles appliquées à une branche.

Pour `main`, on peut imposer :

```text
nombre minimum de reviewers
build obligatoire réussi
work item lié
commentaires résolus
interdiction du push direct
```

Ces règles transforment une bonne pratique en contrainte technique.

Sans policies, l’équipe dépend uniquement de la discipline humaine.

Avec policies, Azure DevOps empêche automatiquement les actions dangereuses.

## Exemple avec Croissant API

Un développeur doit ajouter une route `/health`.

```text
main
  ↓
feature/add-health-endpoint
  ↓
commit : feat: add health endpoint
  ↓
pull request vers main
  ↓
CI : npm install + npm test
  ↓
review
  ↓
merge
```

La CI devient un garde-fou. Si le test échoue, la pull request ne doit pas être mergée.
