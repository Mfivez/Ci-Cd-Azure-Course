# J1 — Déroulé de journée — Fondations DevOps, CI/CD et YAML

## Objectif du jour

À la fin du jour 1, les participants doivent pouvoir expliquer :

- ce qu’est Azure DevOps ;
- ce qu’est un pipeline ;
- la différence entre CI, CD, déploiement et environnement ;
- la structure de base d’un pipeline YAML ;
- le rôle des stages, jobs, steps et agents.

Ils ne doivent pas encore maîtriser le déploiement Azure.

## Progression proposée

| Moment | Sujet | Durée indicative |
|---|---:|---:|
| 1 | Introduction et objectif du parcours 4 jours | 20 min |
| 2 | Pourquoi CI/CD ? Problèmes des livraisons manuelles | 35 min |
| 3 | Azure DevOps en vue d’ensemble | 35 min |
| 4 | CI vs CD vs environnement vs déploiement | 45 min |
| 5 | Pause / questions | 15 min |
| 6 | Pipeline : vocabulaire fondamental | 45 min |
| 7 | YAML : trigger, stages, jobs, steps | 60 min |
| 8 | Démo guidée : pipeline minimal | 45 min |
| 9 | Atelier : lire et modifier un pipeline | 60 min |
| 10 | Quiz et synthèse | 30 min |

## Message clé

> Un pipeline automatise des tâches que l’on faisait manuellement : vérifier, construire, tester et plus tard déployer.

## À ne pas faire le jour 1

- Ne pas entrer dans les secrets.
- Ne pas entrer dans Key Vault.
- Ne pas faire de Blue/Green.
- Ne pas détailler les Branch Policies.
- Ne pas passer trop de temps sur Azure Boards.

## Livrable pédagogique du jour

Les participants repartent avec un pipeline minimal lisible :

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Hello CI/CD"
```
