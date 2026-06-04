# 6. Artefacts de build

Un artefact est ce que le pipeline produit pour être réutilisé ensuite.

Dans une chaîne CI/CD, le pipeline de CI ne doit pas seulement dire “les tests sont verts”. Il doit aussi produire une version exploitable de l’application.

## Pourquoi publier un artefact

Sans artefact, le CD risque de reconstruire l’application au moment du déploiement.

Cela pose un problème :

```text
ce qui est testé n’est pas forcément ce qui est déployé
```

Avec un artefact :

```text
CI construit une version
CI teste cette version
CD déploie cette même version
```

C’est le principe :

```text
Build once, deploy everywhere
```

## Artefact pour Croissant API

Pour Croissant API, on peut créer un fichier zip contenant :

```text
package.json
package-lock.json
src/
test/
```

Dans un vrai projet, on adapterait le contenu selon la technologie.

## Préparer le contenu

On peut copier les fichiers nécessaires dans un dossier temporaire :

```yaml
- script: |
    mkdir -p $(Build.ArtifactStagingDirectory)/app
    cp package*.json $(Build.ArtifactStagingDirectory)/app/
    cp -r src $(Build.ArtifactStagingDirectory)/app/src
  displayName: "Préparer l’artefact"
```

`$(Build.ArtifactStagingDirectory)` est une variable intégrée d’Azure Pipelines. Elle pointe vers un dossier prévu pour préparer les fichiers à publier.

## Publier l’artefact

Azure Pipelines fournit une tâche dédiée :

```yaml
- task: PublishPipelineArtifact@1
  displayName: "Publier l’artefact"
  inputs:
    targetPath: "$(Build.ArtifactStagingDirectory)/app"
    artifact: "croissant-api"
    publishLocation: "pipeline"
```

L’artefact devient disponible dans le run du pipeline.

## Télécharger l’artefact dans un autre stage

Un stage de déploiement peut télécharger l’artefact :

```yaml
- task: DownloadPipelineArtifact@2
  displayName: "Télécharger l’artefact"
  inputs:
    artifact: "croissant-api"
    path: "$(Pipeline.Workspace)/croissant-api"
```

Cela permet de séparer clairement :

```text
CI : construire et tester
CD : déployer ce qui a été construit
```

## Pipeline avec artefact

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    displayName: "Build"
    jobs:
      - job: BuildJob
        displayName: "Construire et publier"
        steps:
          - checkout: self

          - task: NodeTool@0
            displayName: "Installer Node.js"
            inputs:
              versionSpec: "20.x"

          - script: npm ci
            displayName: "Installer les dépendances"

          - script: npm test
            displayName: "Lancer les tests"

          - script: |
              mkdir -p $(Build.ArtifactStagingDirectory)/app
              cp package*.json $(Build.ArtifactStagingDirectory)/app/
              cp -r src $(Build.ArtifactStagingDirectory)/app/src
            displayName: "Préparer l’artefact"

          - task: PublishPipelineArtifact@1
            displayName: "Publier l’artefact"
            inputs:
              targetPath: "$(Build.ArtifactStagingDirectory)/app"
              artifact: "croissant-api"
              publishLocation: "pipeline"
```

## Versionner un artefact

Azure Pipelines expose des variables utiles :

| Variable | Utilisation |
|---|---|
| `$(Build.BuildId)` | identifiant unique du run |
| `$(Build.SourceBranchName)` | branche source |
| `$(Build.Repository.Name)` | nom du repository |
| `$(Build.ArtifactStagingDirectory)` | dossier de préparation |

On peut les utiliser pour nommer ou tracer les livraisons.

Exemple :

```text
croissant-api-$(Build.BuildId)
```

L’identifiant du build permet de retrouver exactement quel pipeline a produit quelle version.
