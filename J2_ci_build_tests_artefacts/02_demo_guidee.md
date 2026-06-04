# J2 — Démo guidée — Pipeline CI avec artefact

## Objectif

Transformer le pipeline minimal du jour 1 en vrai pipeline CI.

## Étape 1 — Montrer la structure du repo

Exemple :

```text
croissant-web/
├── package.json
├── src/
├── tests/
└── azure-pipelines.yml
```

À dire :

> Le pipeline doit pouvoir repartir de zéro sur une machine propre.

## Étape 2 — Installer Node.js

```yaml
- task: NodeTool@0
  inputs:
    versionSpec: '20.x'
  displayName: 'Installer Node.js'
```

## Étape 3 — Installer les dépendances

```yaml
- script: npm ci
  displayName: 'Installer les dépendances'
```

Expliquer la différence simple :

```text
npm install = plus souple
npm ci      = plus reproductible pour CI
```

## Étape 4 — Lancer les tests

```yaml
- script: npm test
  displayName: 'Lancer les tests'
```

Montrer un échec volontaire si possible.

À dire :

> Un pipeline rouge empêche de livrer un code dont on n’a pas confiance.

## Étape 5 — Build

```yaml
- script: npm run build
  displayName: 'Build applicatif'
```

Même si le build est simple, garder cette étape pour montrer la logique.

## Étape 6 — Créer un ZIP

```yaml
- task: ArchiveFiles@2
  inputs:
    rootFolderOrFile: '$(System.DefaultWorkingDirectory)'
    includeRootFolder: false
    archiveType: 'zip'
    archiveFile: '$(Build.ArtifactStagingDirectory)/app.zip'
    replaceExistingArchive: true
  displayName: 'Créer app.zip'
```

## Étape 7 — Publier l’artefact

```yaml
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Build.ArtifactStagingDirectory)'
    artifact: 'drop'
  displayName: 'Publier artefact drop'
```

## Étape 8 — Consulter l’artefact

Dans Azure DevOps :

```text
Pipelines → choisir le run → Artifacts → drop
```

À faire remarquer :

- l’artefact est lié à un run ;
- le run est lié à un commit ;
- on peut savoir quelle version a produit quel artefact.

## Étape 9 — Montrer un déclenchement PR

Ajouter :

```yaml
pr:
  branches:
    include:
      - main
```

Créer ou simuler une PR.

## Étape 10 — Conclusion de la démo

Schéma final :

```text
PR ou push main
  ↓
CI
  ↓
Tests
  ↓
Build
  ↓
Artefact drop
```
