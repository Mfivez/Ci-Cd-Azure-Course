# J3 — Ateliers

## Atelier 1 — Dessiner une chaîne de promotion

Dessiner le flux suivant :

```text
CI → Dev → Staging → Production
```

Ajouter sous chaque environnement :

- qui l’utilise ;
- quelles données il contient ;
- s’il faut une validation humaine.

## Atelier 2 — Compléter un stage Deploy Dev

Compléter :

```yaml
- stage: Deploy_Dev
  dependsOn: CI
  jobs:
    - deployment: DeployDev
      environment: croissant-dev
      strategy:
        runOnce:
          deploy:
            steps:
              # TODO télécharger artefact drop

              # TODO afficher le chemin de l artefact

              # TODO smoke test fictif
```

## Atelier 3 — Variables par environnement

On a 3 environnements : Dev, Staging, Prod.

Proposer des valeurs pour :

```text
APP_NAME
ENVIRONMENT_NAME
RESOURCE_GROUP
```

## Atelier 4 — Service Connection

Répondre :

1. À quoi sert une Service Connection ?
2. Pourquoi éviter un compte personnel ?
3. Pourquoi limiter ses droits ?

## Atelier 5 — Mini quiz

1. Le CD doit reconstruire le code pour chaque environnement. Vrai ou faux ?
2. Un smoke test vérifie rapidement que l’application répond. Vrai ou faux ?
3. Un deployment job peut cibler un Azure DevOps Environment. Vrai ou faux ?
4. Une variable non sensible peut contenir le nom de l’App Service. Vrai ou faux ?
5. Une Service Connection doit avoir tous les droits admin par facilité. Vrai ou faux ?
