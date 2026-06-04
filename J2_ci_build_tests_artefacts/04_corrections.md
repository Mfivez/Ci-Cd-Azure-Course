# J2 — Corrections

## Correction atelier 1

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '20.x'

  - script: npm ci
    displayName: 'Installer les dépendances'

  - script: npm test
    displayName: 'Lancer les tests'

  - script: npm run build
    displayName: 'Build applicatif'
```

## Correction atelier 2

```yaml
- task: ArchiveFiles@2
  inputs:
    rootFolderOrFile: '$(System.DefaultWorkingDirectory)'
    includeRootFolder: false
    archiveType: 'zip'
    archiveFile: '$(Build.ArtifactStagingDirectory)/app.zip'
    replaceExistingArchive: true

- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Build.ArtifactStagingDirectory)'
    artifact: 'drop'
```

## Correction atelier 3

1. C’est un problème détecté par la CI.
2. Non, si les tests échouent, on ne publie normalement pas une version déployable.
3. Non, on ne déploie pas un code dont la CI est rouge.
4. Dans les logs du step `npm test`, puis dans le code ou les tests concernés.

## Correction atelier 4

Règles minimales recommandées :

- A : minimum 1 reviewer ;
- B : build validation obligatoire ;
- D : Work Item obligatoire si la traçabilité projet est demandée.

À éviter :

- C : push direct autorisé ;
- E : force push autorisé.

## Correction atelier 5

1. Faux. On produit l’artefact après les vérifications principales.
2. Vrai.
3. Faux. Cela veut dire construire une fois et déployer le même artefact partout.
4. Faux. La CI réduit le risque, elle ne supprime pas tous les risques.
5. Vrai.
