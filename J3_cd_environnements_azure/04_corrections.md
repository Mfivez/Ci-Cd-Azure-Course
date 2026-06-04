# J3 — Corrections

## Correction atelier 1

Exemple :

```text
CI
  ↓
Dev : équipe dev, données de test, automatique
  ↓
Staging : QA / métier, données proches prod ou anonymisées, validation possible
  ↓
Production : utilisateurs réels, données réelles, validation humaine recommandée
```

## Correction atelier 2

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
              - download: current
                artifact: drop

              - script: echo "Artefact = $(Pipeline.Workspace)/drop/app.zip"
                displayName: 'Afficher artefact'

              - script: echo "Smoke test fictif OK"
                displayName: 'Smoke test'
```

## Correction atelier 3

Exemple :

| Variable | Dev | Staging | Prod |
|---|---|---|---|
| APP_NAME | croissant-web-dev | croissant-web-staging | croissant-web-prod |
| ENVIRONMENT_NAME | dev | staging | production |
| RESOURCE_GROUP | rg-croissant-dev | rg-croissant-staging | rg-croissant-prod |

## Correction atelier 4

1. Elle permet au pipeline de se connecter à Azure ou à un autre service externe.
2. Un compte personnel dépend d’une personne, peut quitter l’entreprise, et pose des problèmes d’audit.
3. Pour appliquer le principe du moindre privilège et limiter l’impact en cas d’erreur ou de compromission.

## Correction atelier 5

1. Faux. Il doit déployer le même artefact.
2. Vrai.
3. Vrai.
4. Vrai.
5. Faux.
