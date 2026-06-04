# J4 — Cours — Production propre : approvals, secrets, slots et rollback

## 1. Pourquoi ne pas déployer directement en production ?

Déployer directement en production augmente le risque :

```text
Pipeline → Production
```

Problèmes possibles :

- erreur visible par les utilisateurs ;
- pas de validation intermédiaire ;
- rollback difficile ;
- secrets mal protégés ;
- personne ne sait qui a validé ;
- plusieurs déploiements se marchent dessus.

Approche plus propre :

```text
Pipeline → Staging → Tests → Approval → Production
```

## 2. La production doit être protégée

La production contient :

- les vrais utilisateurs ;
- les vraies données ;
- l’image de l’entreprise ;
- des impacts financiers ou métier.

Phrase :

> Automatiser ne veut pas dire supprimer tous les contrôles.

## 3. Approvals and Checks

Azure DevOps permet de configurer des contrôles sur les environnements.

Exemples :

| Check | Rôle |
|---|---|
| Approval | une personne valide avant déploiement |
| Branch control | seules certaines branches peuvent déployer |
| Exclusive lock | un seul déploiement à la fois |
| Query Azure Monitor alerts | bloque si l’environnement est déjà dégradé |
| Invoke REST API | appelle un système externe avant de continuer |

Pour un premier cours, garder :

```text
Approval + Branch control + Exclusive lock
```

## 4. Approval humaine

Une approval permet d’attendre une validation avant de continuer.

Exemple :

```text
Deploy Staging OK
  ↓
Attente validation Tech Lead / PO
  ↓
Deploy Production
```

Intérêt :

- trace de qui a validé ;
- pause avant étape sensible ;
- responsabilité claire ;
- meilleur contrôle des changements.

## 5. Branch control

Branch control permet d’éviter qu’une branche de feature déploie en production.

Règle typique :

```text
production accepte seulement main ou release/*
```

À dire :

> Même si le YAML contient un stage production, l’environnement peut bloquer le déploiement.

## 6. Exclusive lock

Exclusive lock évite deux déploiements simultanés sur le même environnement.

Exemple :

```text
Pipeline A déploie en staging
Pipeline B attend
```

Utile pour éviter les collisions.

## 7. Variables et secrets

Différence :

| Type | Exemple | Sensible ? |
|---|---|---|
| Variable | APP_NAME | Non |
| Variable | ENVIRONMENT_NAME | Non |
| Secret | DATABASE_PASSWORD | Oui |
| Secret | API_KEY | Oui |

Règle :

> Les secrets ne vont jamais en clair dans Git ni dans le YAML.

## 8. Variable Groups

Un Variable Group centralise des variables pour plusieurs pipelines.

Exemple :

```text
croissant-dev
  APP_NAME = croissant-web-dev
  ENVIRONMENT_NAME = dev

croissant-prod
  APP_NAME = croissant-web-prod
  ENVIRONMENT_NAME = production
  DATABASE_PASSWORD = ***
```

Dans YAML :

```yaml
variables:
  - group: croissant-prod
```

Utilisation :

```yaml
- script: echo "App = $(APP_NAME)"
```

## 9. Key Vault en introduction

Azure Key Vault est le coffre-fort Azure pour :

- secrets ;
- certificats ;
- clés.

Dans un pipeline, on peut lier un Variable Group à Key Vault.

À dire simplement :

> Azure DevOps orchestre le déploiement. Key Vault garde les secrets.

## 10. Règles d’or secrets

1. Ne jamais committer un secret.
2. Ne jamais écrire un secret dans un YAML.
3. Marquer les variables sensibles comme secrètes.
4. Limiter l’accès aux Variable Groups.
5. Utiliser Key Vault pour les secrets applicatifs importants.
6. Prévoir la rotation des secrets.

## 11. Blue/Green

Blue/Green consiste à garder deux versions :

```text
Blue  = version actuelle en production
Green = nouvelle version préparée à côté
```

Une fois Green validée, on bascule.

Avantage :

- moins d’interruption ;
- validation avant exposition ;
- rollback plus simple.

## 12. Azure App Service Deployment Slots

Avec Azure App Service, on peut utiliser des slots :

```text
production
staging
```

Processus :

```text
1. production contient v1
2. staging reçoit v2
3. on teste staging
4. on swap staging → production
5. production sert v2
6. staging garde v1
```

## 13. Déployer sur slot staging

```yaml
- task: AzureWebApp@1
  displayName: 'Déployer sur slot staging'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    appType: 'webAppLinux'
    appName: 'croissant-web-prod'
    deployToSlotOrASE: true
    resourceGroupName: 'rg-croissant-prod'
    slotName: 'staging'
    package: '$(Pipeline.Workspace)/drop/app.zip'
```

## 14. Smoke test sur slot staging

```yaml
- script: |
    curl -f https://croissant-web-prod-staging.azurewebsites.net/health
  displayName: 'Smoke test slot staging'
```

## 15. Swap staging vers production

```yaml
- task: AzureAppServiceManage@0
  displayName: 'Swap staging vers production'
  inputs:
    azureSubscription: 'Azure-Prod-SC'
    Action: 'Swap Slots'
    WebAppName: 'croissant-web-prod'
    ResourceGroupName: 'rg-croissant-prod'
    SourceSlot: 'staging'
    SwapWithProduction: true
```

## 16. Rollback

Rollback = retour arrière.

Avec slots :

```text
Après swap :
production = v2
staging    = v1

Rollback :
swap inverse
production = v1
staging    = v2
```

Phrase essentielle :

> On ne doit pas inventer le rollback pendant l’incident. Il doit être prévu dans la stratégie de déploiement.

## 17. Monitoring post-déploiement

Après production, vérifier :

- est-ce que `/health` répond ?
- le taux d’erreur augmente-t-il ?
- la latence augmente-t-elle ?
- les logs montrent-ils des erreurs ?
- les utilisateurs signalent-ils un problème ?

Smoke test prod :

```yaml
- script: curl -f https://croissant-web-prod.azurewebsites.net/health
  displayName: 'Smoke test production'
```

## 18. Templates YAML en introduction

Quand plusieurs pipelines répètent les mêmes étapes, on peut utiliser des templates.

Exemple :

```text
templates/build-node.yml
templates/deploy-appservice.yml
```

À dire :

> Les templates évitent de copier-coller les mêmes étapes partout.

Ne pas approfondir plus si le groupe débute.

## 19. Pipeline final conceptuel

```text
Commit sur main
  ↓
CI : restore + tests + build
  ↓
Artefact drop
  ↓
Deploy Dev automatique
  ↓
Smoke test Dev
  ↓
Deploy Staging automatique ou contrôlé
  ↓
Smoke test Staging
  ↓
Approval Production
  ↓
Deploy slot staging
  ↓
Smoke test slot staging
  ↓
Swap vers Production
  ↓
Smoke test Production
  ↓
Monitoring
  ↓
Rollback si nécessaire
```

## 20. Checklist finale

Avant de considérer la chaîne CI/CD correcte :

- pipeline YAML versionné ;
- CI lancée sur PR et main ;
- tests automatiques ;
- artefact unique publié ;
- Dev/Staging/Prod séparés ;
- variables séparées des secrets ;
- secrets protégés ;
- Service Connection à droits limités ;
- production avec approval ;
- branch control sur production ;
- smoke tests ;
- rollback documenté ;
- monitoring minimal ;
- historique de déploiement visible.

## 21. Résumé des 4 jours

```text
J1 : comprendre le vocabulaire et lire un pipeline
J2 : construire une CI qui produit un artefact
J3 : déployer l’artefact en Dev et Staging
J4 : protéger la production, gérer les secrets et prévoir le rollback
```

Phrase finale :

> La qualité d’une chaîne CI/CD ne se mesure pas seulement à sa vitesse, mais à sa capacité à livrer souvent, proprement, en sécurité et avec retour arrière possible.
