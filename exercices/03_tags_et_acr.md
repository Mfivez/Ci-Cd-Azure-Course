# Exercice 3 — Choisir une stratégie de tags

On veut publier les images Docker de Croissant API dans ACR.

Répondre aux questions :

1. Pourquoi `latest` seul n’est pas suffisant ?
2. Quel tag permet de relier une image à un run Azure Pipelines ?
3. Proposer deux tags pour une image construite depuis `main`.
4. Proposer un tag pour une version officielle `1.2.0`.

Compléter :

```yaml
variables:
  imageRepository: ______
  imageTag: ______
```
