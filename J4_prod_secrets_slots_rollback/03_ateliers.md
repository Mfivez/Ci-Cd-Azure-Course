# J4 — Ateliers

## Atelier 1 — Choisir les protections production

Pour l’environnement production, choisir les protections utiles :

```text
A. Approval humaine
B. Branch control main uniquement
C. Exclusive lock
D. Aucun contrôle pour aller plus vite
E. Smoke test après déploiement
```

Justifier chaque choix.

## Atelier 2 — Classer variables et secrets

Classer : variable ou secret.

```text
APP_NAME
RESOURCE_GROUP
ENVIRONMENT_NAME
DATABASE_PASSWORD
API_KEY
LOG_LEVEL
```

## Atelier 3 — Compléter un stage production

Compléter :

```yaml
- stage: Deploy_Production
  dependsOn: Deploy_Staging
  jobs:
    - deployment: DeployProduction
      environment: croissant-production
      strategy:
        runOnce:
          deploy:
            steps:
              # TODO télécharger artefact
              # TODO déployer sur slot staging
              # TODO smoke test staging
              # TODO swap vers production
              # TODO smoke test production
```

## Atelier 4 — Scénario rollback

Scénario :

```text
La version v2 vient d’être swappée en production.
Les utilisateurs reçoivent des erreurs 500.
Le slot staging contient encore v1.
```

Questions :

1. Quelle action faire rapidement ?
2. Pourquoi les slots aident-ils ?
3. Que faut-il vérifier après rollback ?
4. Faut-il supprimer v2 directement ?

## Atelier 5 — Atelier final : dessiner le pipeline complet

Dessiner un pipeline complet avec :

- CI ;
- artefact ;
- Dev ;
- Staging ;
- approval ;
- production slot staging ;
- swap ;
- smoke tests ;
- rollback.

## Atelier 6 — Mini quiz

1. Un secret peut être écrit dans le YAML si le repo est privé. Vrai ou faux ?
2. Une approval permet de tracer qui a validé. Vrai ou faux ?
3. Blue/Green facilite le rollback. Vrai ou faux ?
4. Un smoke test remplace tous les tests fonctionnels. Vrai ou faux ?
5. Branch control peut empêcher une feature branch de déployer en production. Vrai ou faux ?
