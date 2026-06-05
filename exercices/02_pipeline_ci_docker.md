# Exercice 2 — Créer une CI Docker-first

Compléter le pipeline suivant pour :

1. Se déclencher sur `main`.
2. Utiliser `ubuntu-latest`.
3. Lancer `npm test`.
4. Construire l’image Docker avec le tag `$(Build.BuildId)`.
5. Démarrer le conteneur et vérifier `/health`.

```yaml
trigger:
  - ______

pool:
  vmImage: ______

variables:
  imageName: croissant-api
  imageTag: ______

steps:
  - script: ______
    displayName: "Tests"

  - script: docker build -t $(imageName):$(imageTag) .
    displayName: "Docker build"

  - script: |
      docker run -d --name croissant-api-test -p 8080:8080 $(imageName):$(imageTag)
      sleep 5
      curl --fail http://localhost:8080/______
      docker rm -f croissant-api-test
    displayName: "Smoke test"
```
