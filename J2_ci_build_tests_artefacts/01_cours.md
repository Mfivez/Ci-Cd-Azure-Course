# J2 — Cours — CI : build, tests, qualité et artefacts

## 1. Rappel du jour 1

On a vu :

```text
Pipeline
  Stage
    Job
      Step
```

Aujourd’hui, on donne un vrai objectif au pipeline : faire de la CI.

## 2. Objectif de la CI

La CI répond à la question :

> Est-ce que le code peut être intégré sans casser le projet ?

Un bon pipeline CI doit :

1. partir d’un code propre ;
2. installer les dépendances ;
3. lancer les tests ;
4. construire l’application ;
5. publier les résultats ;
6. produire un artefact.

Schéma :

```text
Push ou PR
  ↓
Restore
  ↓
Tests
  ↓
Build
  ↓
Artefact
```

## 3. Pourquoi installer les dépendances dans le pipeline ?

Parce que le pipeline doit être reproductible.

Mauvaise idée :

```text
Ça marche sur ma machine donc c’est bon.
```

Bonne idée :

```text
Ça marche sur une machine propre fournie par Azure DevOps.
```

Avec Node.js :

```yaml
- script: npm ci
  displayName: 'Installer les dépendances'
```

Avec .NET :

```yaml
- task: DotNetCoreCLI@2
  inputs:
    command: restore
    projects: '**/*.csproj'
```

## 4. Tests dans la CI

Les tests permettent de bloquer rapidement une régression.

Exemple Node.js :

```yaml
- script: npm test
  displayName: 'Lancer les tests'
```

Exemple .NET :

```yaml
- task: DotNetCoreCLI@2
  inputs:
    command: test
    projects: '**/*Tests/*.csproj'
```

À dire :

> Un test qui échoue dans la CI coûte beaucoup moins cher qu’un bug découvert en production.

## 5. Shift Left

Le Shift Left consiste à déplacer les contrôles qualité et sécurité le plus tôt possible.

```text
Avant : tester tard, parfois après déploiement
Après : tester dès le commit ou la Pull Request
```

Exemples :

- tests unitaires ;
- lint ;
- scan de dépendances ;
- scan de secrets ;
- analyse de code.

Ne pas approfondir tous les outils maintenant. Garder le principe.

## 6. Build applicatif

Le build transforme le code en résultat exploitable.

Exemples :

```yaml
- script: npm run build
  displayName: 'Build applicatif'
```

ou :

```yaml
- task: DotNetCoreCLI@2
  inputs:
    command: publish
    projects: '**/*.csproj'
    arguments: '--configuration Release --output $(Build.ArtifactStagingDirectory)/app'
```

## 7. Artefact

Un artefact est ce qui va être déployé plus tard.

Exemples :

```text
app.zip
build React
.jar
package NuGet
image Docker
```

Phrase à retenir :

> En CI, on produit l’artefact. En CD, on déploie l’artefact.

## 8. Build Once, Deploy Everywhere

Principe :

```text
Construire une fois
Déployer le même résultat partout
```

Mauvais modèle :

```text
Build pour Dev
Build différent pour Staging
Build différent pour Prod
```

Bon modèle :

```text
Build une fois
  ↓
Artefact v123
  ↓
Dev
  ↓
Staging
  ↓
Prod
```

Pourquoi ?

- on déploie exactement ce qui a été testé ;
- on évite les différences invisibles ;
- on facilite le rollback ;
- on améliore la traçabilité.

## 9. Publier un artefact dans Azure Pipelines

Exemple générique :

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

Le nom `drop` est courant, mais on peut choisir un autre nom.

## 10. Variables utiles dans Azure Pipelines

| Variable | Rôle |
|---|---|
| `$(Build.BuildId)` | identifiant unique du run |
| `$(Build.SourceBranchName)` | nom de la branche |
| `$(System.DefaultWorkingDirectory)` | dossier de travail |
| `$(Build.ArtifactStagingDirectory)` | dossier temporaire pour préparer l’artefact |
| `$(Pipeline.Workspace)` | dossier utilisé entre stages |

Exemple :

```yaml
- script: echo "Build id = $(Build.BuildId)"
```

## 11. Pipeline CI complet Node.js

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: CI
    displayName: 'CI - Build et tests'
    jobs:
      - job: BuildAndTest
        displayName: 'Build et test'
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '20.x'
            displayName: 'Installer Node.js'

          - script: npm ci
            displayName: 'Installer les dépendances'

          - script: npm test
            displayName: 'Lancer les tests'

          - script: npm run build
            displayName: 'Build applicatif'

          - task: ArchiveFiles@2
            inputs:
              rootFolderOrFile: '$(System.DefaultWorkingDirectory)'
              includeRootFolder: false
              archiveType: 'zip'
              archiveFile: '$(Build.ArtifactStagingDirectory)/app.zip'
              replaceExistingArchive: true
            displayName: 'Créer app.zip'

          - task: PublishPipelineArtifact@1
            inputs:
              targetPath: '$(Build.ArtifactStagingDirectory)'
              artifact: 'drop'
            displayName: 'Publier artefact drop'
```

## 12. Pull Request et validation automatique

Une Pull Request permet de relire le code avant fusion.

La CI peut être utilisée comme garde-fou :

```text
PR ouverte
  ↓
Pipeline CI lancé
  ↓
Tests OK ?
  ↓
Review OK ?
  ↓
Merge autorisé
```

## 13. Branch Policies

Les Branch Policies protègent une branche comme `main`.

Politiques utiles :

- interdire le push direct ;
- obliger une Pull Request ;
- obliger un reviewer ;
- obliger un build réussi ;
- obliger un Work Item lié si le contexte le demande.

À dire :

> La CI est encore plus utile quand elle bloque automatiquement le merge d’un code cassé.

## 14. Résumé du jour

À retenir :

```text
CI = restore + tests + build + artefact
Artefact = résultat déployable
Build once, deploy everywhere = même version partout
PR validation = CI comme garde-fou avant main
Branch policies = règles techniques pour protéger le code
```
