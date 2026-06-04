# J1 — Cours — Fondations DevOps, CI/CD et YAML

## 1. Pourquoi parler de DevOps ?

Dans beaucoup de projets, les livraisons manuelles créent des problèmes :

- une personne déploie depuis sa machine ;
- les étapes ne sont pas toujours documentées ;
- les tests sont oubliés ou lancés trop tard ;
- la production fait peur ;
- en cas d’incident, personne ne sait exactement ce qui a été livré.

Le DevOps cherche à rapprocher développement, opérations et qualité autour d’un cycle plus fiable.

Phrase simple :

> DevOps, ce n’est pas seulement un outil. C’est une manière d’automatiser et de fiabiliser la livraison du logiciel.

## 2. Azure DevOps en une phrase

Azure DevOps est une plateforme qui regroupe plusieurs services pour gérer le cycle de vie logiciel.

Services principaux :

| Service | Rôle simple |
|---|---|
| Azure Boards | suivre le travail, les tâches, les bugs |
| Azure Repos | héberger le code Git |
| Azure Pipelines | automatiser CI/CD |
| Azure Test Plans | organiser des tests manuels et exploratoires |
| Azure Artifacts | stocker des packages et artefacts |

Pour ce cours, le cœur du sujet est :

```text
Azure Repos + Azure Pipelines + Environments + Artifacts
```

## 3. Le problème sans pipeline

Sans pipeline, une livraison peut ressembler à ça :

```text
Développeur modifie le code
  ↓
Il pense avoir testé
  ↓
Il copie des fichiers à la main
  ↓
Il oublie une variable
  ↓
La production casse
```

Avec un pipeline :

```text
Développeur pousse le code
  ↓
Pipeline automatique
  ↓
Build
  ↓
Tests
  ↓
Artefact
  ↓
Déploiement contrôlé
```

## 4. CI, CD, déploiement et environnement

Ces mots sont souvent mélangés. Il faut les séparer.

| Mot | Question à laquelle il répond |
|---|---|
| CI | Est-ce que le code est correct et intégrable ? |
| CD | Comment livrer cette version ? |
| Déploiement | Action de mettre l’application quelque part |
| Environnement | Endroit où l’application tourne |

Schéma :

```text
Code source
  ↓
CI : build + tests
  ↓
Artefact
  ↓
CD : déploiement
  ↓
Dev / Test / Staging / Production
```

## 5. CI — Continuous Integration

La CI démarre souvent à chaque push ou Pull Request.

Elle vérifie :

- que le code compile ;
- que les dépendances s’installent ;
- que les tests passent ;
- que le code respecte certaines règles de qualité ;
- que l’on peut produire une version déployable.

À dire :

> La CI donne un feedback rapide aux développeurs.

## 6. CD — Continuous Delivery / Deployment

Le CD commence quand la CI a produit quelque chose de fiable.

Il sert à :

- récupérer l’artefact ;
- choisir un environnement ;
- appliquer la bonne configuration ;
- déployer ;
- vérifier que l’application répond ;
- éventuellement demander une validation humaine ;
- prévoir le rollback.

Différence :

| Terme | Explication |
|---|---|
| Continuous Delivery | la version est prête à être déployée, souvent avec validation humaine |
| Continuous Deployment | la version va automatiquement jusqu’à la production |

## 7. Pipeline

Un pipeline est une recette automatisée.

Exemple très simple :

```text
1. Prendre le code
2. Installer les dépendances
3. Lancer les tests
4. Construire l’application
5. Publier le résultat
```

Dans Azure DevOps, cette recette est souvent décrite en YAML.

## 8. YAML vs Classic

Azure DevOps permet deux approches :

| Approche | Description |
|---|---|
| Classic | configuration via interface graphique |
| YAML | pipeline écrit dans un fichier versionné avec le code |

Pour un cours moderne, privilégier YAML.

Avantages du YAML :

- versionné dans Git ;
- relu en Pull Request ;
- copiable et réutilisable ;
- traçable ;
- cohérent avec l’idée de configuration as code.

## 9. Anatomie d’un pipeline Azure DevOps

Hiérarchie :

```text
Pipeline
  ├── Trigger
  ├── Stage
  │   └── Job
  │       └── Step
  └── Variables
```

### Trigger

Le trigger dit quand démarrer.

```yaml
trigger:
  - main
```

Ici : le pipeline démarre quand on pousse sur `main`.

### Pool et agent

Le pool indique où le pipeline s’exécute.

```yaml
pool:
  vmImage: ubuntu-latest
```

Ici : Azure DevOps fournit une machine Ubuntu temporaire.

### Step

Un step est une action.

```yaml
steps:
  - script: echo "Hello pipeline"
```

### Job

Un job regroupe des steps.

```yaml
jobs:
  - job: BuildJob
    steps:
      - script: echo "Build"
```

### Stage

Un stage regroupe un ou plusieurs jobs.

```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "Build"
```

## 10. Premier pipeline complet mais simple

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

stages:
  - stage: Build
    displayName: "Build et vérification"
    jobs:
      - job: BuildJob
        displayName: "Job de build"
        steps:
          - script: echo "Récupération du code faite automatiquement"
            displayName: "Info"

          - script: echo "Installation des dépendances"
            displayName: "Installer"

          - script: echo "Tests"
            displayName: "Tester"
```

## 11. Point très important : le YAML est sensible à l’indentation

Exemple incorrect :

```yaml
steps:
- script: echo "ok"
    displayName: "mauvaise indentation"
```

Exemple correct :

```yaml
steps:
  - script: echo "ok"
    displayName: "bonne indentation"
```

## 12. Résumé du jour

À retenir :

```text
Pipeline = automatisation
CI = vérification du code
CD = livraison/déploiement
Stage = grande phase
Job = bloc de travail sur un agent
Step = action précise
Agent = machine qui exécute
YAML = pipeline versionné dans Git
```
