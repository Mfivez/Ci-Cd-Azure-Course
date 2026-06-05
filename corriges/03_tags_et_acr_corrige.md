# Corrigé 3 — Choisir une stratégie de tags

`latest` seul n’est pas suffisant, car il ne permet pas d’identifier précisément la version déployée.

`$(Build.BuildId)` permet de relier une image à un run Azure Pipelines.

Exemples de tags depuis `main` :

```text
128
main-128
```

Tag pour une version officielle :

```text
1.2.0
```

YAML :

```yaml
variables:
  imageRepository: croissant-api
  imageTag: $(Build.BuildId)
```
