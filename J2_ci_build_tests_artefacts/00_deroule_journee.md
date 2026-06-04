# J2 — Déroulé de journée — CI : build, tests, qualité et artefacts

## Objectif du jour

À la fin du jour 2, les participants doivent comprendre et savoir lire un pipeline CI qui :

- installe les dépendances ;
- lance les tests ;
- build l’application ;
- publie un artefact ;
- sert de validation pour une Pull Request.

## Progression proposée

| Moment | Sujet | Durée indicative |
|---|---:|---:|
| 1 | Rappel J1 | 20 min |
| 2 | Objectif de la CI | 30 min |
| 3 | Pipeline CI simple Node ou .NET | 60 min |
| 4 | Logs et erreurs fréquentes | 35 min |
| 5 | Pause | 15 min |
| 6 | Tests et Shift Left | 45 min |
| 7 | Artefact et Build Once Deploy Everywhere | 45 min |
| 8 | Démo guidée : publier un artefact | 60 min |
| 9 | Branch policies et PR validation | 40 min |
| 10 | Atelier CI complet | 70 min |
| 11 | Quiz et synthèse | 30 min |

## Message clé

> La CI ne sert pas seulement à lancer des tests. Elle produit une version fiable et traçable que le CD pourra déployer.

## À éviter le jour 2

- Ne pas parler trop longtemps de SonarQube.
- Ne pas configurer Key Vault.
- Ne pas faire de déploiement production.
- Ne pas entrer dans RBAC avancé.

## Livrable pédagogique du jour

Un pipeline CI avec un artefact `drop`.
