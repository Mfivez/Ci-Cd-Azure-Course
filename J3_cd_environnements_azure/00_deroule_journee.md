# J3 — Déroulé de journée — CD et environnements Azure

## Objectif du jour

À la fin du jour 3, les participants doivent comprendre comment un artefact validé est déployé vers plusieurs environnements.

Ils doivent savoir lire un pipeline multi-stage :

```text
CI → Deploy Dev → Deploy Staging
```

## Progression proposée

| Moment | Sujet | Durée indicative |
|---|---:|---:|
| 1 | Rappel J2 : artefact | 20 min |
| 2 | Objectif du CD | 30 min |
| 3 | Environnements Dev, Test, Staging, Prod | 45 min |
| 4 | Continuous Delivery vs Continuous Deployment | 25 min |
| 5 | Azure App Service en cible simple | 40 min |
| 6 | Pause | 15 min |
| 7 | Azure DevOps Environments | 45 min |
| 8 | Variables par environnement | 45 min |
| 9 | Service Connections | 35 min |
| 10 | Démo : pipeline Dev → Staging | 75 min |
| 11 | Smoke tests | 30 min |
| 12 | Atelier et synthèse | 60 min |

## Message clé

> Le CD ne reconstruit pas le code. Il prend un artefact validé et le déploie avec la bonne configuration.

## À éviter le jour 3

- Ne pas faire la production finale si le groupe n’est pas prêt.
- Ne pas détailler Key Vault.
- Ne pas entrer dans Blue/Green complet.
- Ne pas expliquer toute l’administration Azure.

## Livrable pédagogique du jour

Un pipeline conceptuel ou réel :

```text
CI → Deploy_Dev → Deploy_Staging
```
