# J1 — Ateliers

## Atelier 1 — Classer les concepts

Classer chaque élément dans la bonne catégorie : CI, CD, environnement, pipeline, artefact.

Éléments :

```text
npm test
production
app.zip
staging
Déployer sur Azure App Service
stage Build
lancer un smoke test
ubuntu-latest
```

## Atelier 2 — Lire un pipeline

Lire ce pipeline et répondre aux questions.

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "Install"
          - script: echo "Test"
          - script: echo "Build"
```

Questions :

1. Quand le pipeline démarre-t-il ?
2. Sur quelle machine s’exécute-t-il ?
3. Combien y a-t-il de stages ?
4. Combien y a-t-il de jobs ?
5. Combien y a-t-il de steps ?

## Atelier 3 — Corriger l’indentation

Corriger ce YAML :

```yaml
trigger:
- main

pool:
vmImage: ubuntu-latest

steps:
- script: echo "Hello"
 displayName: "Test"
```

## Atelier 4 — Transformer une procédure manuelle en pipeline

Procédure manuelle :

```text
1. Ouvrir un terminal
2. Installer les dépendances
3. Lancer les tests
4. Générer le build
5. Copier le résultat dans un dossier
```

Écrire un pseudo-pipeline sous forme de liste.

## Atelier 5 — Mini quiz

1. La CI sert principalement à déployer en production. Vrai ou faux ?
2. Le CD commence généralement après une CI réussie. Vrai ou faux ?
3. Un environnement est une branche Git. Vrai ou faux ?
4. Un step est plus petit qu’un job. Vrai ou faux ?
5. YAML est sensible à l’indentation. Vrai ou faux ?
