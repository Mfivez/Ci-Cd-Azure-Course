# J4 — Déroulé de journée — Production, secrets, slots et rollback

## Objectif du jour

À la fin du jour 4, les participants doivent comprendre comment rendre un déploiement production plus sûr :

- approvals ;
- checks ;
- secrets ;
- Key Vault en introduction ;
- Deployment Slots ;
- swap ;
- rollback ;
- monitoring léger ;
- checklist finale.

## Progression proposée

| Moment | Sujet | Durée indicative |
|---|---:|---:|
| 1 | Rappel J3 : Dev → Staging | 20 min |
| 2 | Pourquoi protéger la production ? | 30 min |
| 3 | Azure DevOps Approvals and Checks | 50 min |
| 4 | Variables, secrets et Variable Groups | 60 min |
| 5 | Pause | 15 min |
| 6 | Key Vault en introduction | 35 min |
| 7 | Blue/Green et App Service Slots | 60 min |
| 8 | Démo : staging slot + swap | 60 min |
| 9 | Rollback | 35 min |
| 10 | Monitoring et checklist finale | 45 min |
| 11 | Atelier final | 75 min |
| 12 | Synthèse 4 jours | 30 min |

## Message clé

> Un déploiement professionnel n’est pas seulement automatique. Il est contrôlé, sécurisé, observable et réversible.

## À éviter

- Ne pas détailler Canary, AKS ou Terraform.
- Ne pas faire de RBAC complet.
- Ne pas faire de sécurité avancée en profondeur.

## Livrable pédagogique du jour

Un pipeline final conceptuel :

```text
CI → Dev → Staging → Approval → Slot staging → Swap Prod → Smoke test → Rollback possible
```
