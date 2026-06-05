# Corrigé 2 — Créer une CI Docker-first

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

variables:
  imageName: croissant-api
  imageTag: $(Build.BuildId)

steps:
  - script: npm test
    displayName: "Tests"

  - script: docker build -t $(imageName):$(imageTag) .
    displayName: "Docker build"

  - script: |
      docker run -d --name croissant-api-test -p 8080:8080 $(imageName):$(imageTag)
      sleep 5
      curl --fail http://localhost:8080/health
      docker rm -f croissant-api-test
    displayName: "Smoke test"
```
