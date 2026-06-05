# Chapitre 2 — GitHub comme source du code, Azure Pipelines comme moteur

Le code de Croissant API vit dans GitHub.

```text
GitHub
   └── croissant-api
        ├── src/
        ├── test/
        ├── Dockerfile
        ├── package.json
        └── azure-pipelines.yml
```

Azure DevOps n’a pas besoin de posséder ce code dans Azure Repos. Azure Pipelines peut être connecté à un repository GitHub.

Cela donne l’architecture suivante :

```text
GitHub contient le code
        ↓
Azure Pipelines récupère le code
        ↓
Azure Pipelines exécute le YAML
        ↓
Azure reçoit l’image ou le déploiement
```

## Ce que signifie “Azure Pipelines lit le repo GitHub”

Quand un pipeline est connecté à GitHub, Azure DevOps a l’autorisation de consulter le repository sélectionné. Lorsqu’un événement se produit, par exemple un push ou une pull request, Azure Pipelines démarre un run.

Le run exécute en gros cette logique :

```text
1. démarrer un agent
2. faire un checkout du repository GitHub
3. lire azure-pipelines.yml
4. exécuter les étapes décrites dans le YAML
```

L’agent exécute les commandes sur une copie du code.

```text
GitHub
   ↓ checkout
Agent Azure Pipelines
   ↓
npm test
   ↓
docker build
   ↓
docker push
```

Le code reste dans GitHub. Azure Pipelines ne remplace pas GitHub. Il se branche dessus.

## GitHub comme source de vérité

Si une équipe utilise déjà GitHub, il est souvent plus simple de le garder comme source principale.

```text
GitHub = code source et pull requests
Azure Pipelines = automatisation CI/CD
Azure = hébergement et services cloud
```

Importer un repo GitHub dans Azure Repos crée une copie. Cette copie ne se synchronise pas automatiquement avec GitHub, sauf si une synchronisation est mise en place séparément.

Dans ce cours, le modèle reste donc :

```text
GitHub d’abord
Azure Pipelines ensuite
Azure comme cible finale
```

## Événements qui déclenchent le pipeline

Un pipeline peut réagir à plusieurs événements.

| Événement | Utilisation |
|---|---|
| push sur `main` | construire et livrer une version |
| pull request vers `main` | valider avant intégration |
| tag Git | créer une version officielle |
| exécution manuelle | relancer ou déployer une version particulière |

Exemple YAML :

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main
```

Ici :

```text
push sur main → pipeline
pull request vers main → pipeline
```

## Pull request et CI

La pull request est un point de contrôle.

```text
branche feature
   ↓
pull request
   ↓
CI automatique
   ↓
review humaine
   ↓
merge vers main
```

Le pipeline exécuté sur pull request ne doit pas forcément déployer. Il doit surtout vérifier.

```text
vérifier les tests
vérifier le Dockerfile
vérifier que l’image peut être construite
```

Le pipeline sur `main`, lui, peut produire et pousser une image versionnée dans un registry.

```text
merge vers main
   ↓
tests
   ↓
docker build
   ↓
docker push
```

## Azure DevOps et GitHub : rôle de l’autorisation

Pour qu’Azure Pipelines puisse accéder à GitHub, une autorisation est nécessaire. Elle se fait lors de la création du pipeline dans Azure DevOps.

Chemin typique :

```text
Azure DevOps
   ↓
Pipelines
   ↓
New pipeline
   ↓
GitHub
   ↓
Sélectionner le repository
   ↓
Choisir ou créer azure-pipelines.yml
```

Une fois la connexion créée, Azure DevOps peut réagir aux changements du repo GitHub.

## Ce qu’il faut retenir

```text
GitHub garde le code.
Azure Pipelines récupère le code au moment du run.
azure-pipelines.yml décrit ce qu’il faut faire.
L’agent exécute les commandes.
Azure reçoit l’image ou le déploiement.
```
