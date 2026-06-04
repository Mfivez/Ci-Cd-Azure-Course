# J1 — Corrections

## Correction atelier 1

| Élément | Catégorie |
|---|---|
| npm test | CI |
| production | environnement |
| app.zip | artefact |
| staging | environnement |
| Déployer sur Azure App Service | CD / déploiement |
| stage Build | pipeline |
| lancer un smoke test | CD / validation post-déploiement |
| ubuntu-latest | agent / pool |

## Correction atelier 2

1. Le pipeline démarre sur un changement de la branche `main`.
2. Il s’exécute sur une machine Microsoft-hosted `ubuntu-latest`.
3. Il y a 1 stage : `Build`.
4. Il y a 1 job : `BuildJob`.
5. Il y a 3 steps.

## Correction atelier 3

Version correcte possible :

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - script: echo "Hello"
    displayName: "Test"
```

## Correction atelier 4

Pseudo-pipeline :

```text
trigger sur main
  ↓
installer dépendances
  ↓
lancer tests
  ↓
générer build
  ↓
publier résultat
```

## Correction atelier 5

1. Faux. La CI sert d’abord à vérifier le code.
2. Vrai.
3. Faux. Un environnement est un endroit où l’application tourne avec sa configuration.
4. Vrai.
5. Vrai.
