# Checklist formateur

## Avant le jour 1

- Vérifier le niveau Git des participants.
- Préparer un repo de démonstration simple.
- Avoir un exemple de pipeline YAML minimal.
- Prévoir des schémas simples au tableau.
- Ne pas commencer par Azure Portal trop vite.

## Avant le jour 2

- Préparer un pipeline CI qui réussit.
- Préparer un pipeline CI volontairement cassé.
- Préparer un exemple d’artefact visible dans Azure DevOps.
- Préparer un exemple de Pull Request.
- Vérifier que les participants savent lire les logs.

## Avant le jour 3

- Préparer les environnements Azure DevOps : `croissant-dev`, `croissant-staging`.
- Préparer une Service Connection Azure, ou simuler avec des `echo` si l’abonnement Azure n’est pas disponible.
- Préparer des variables par environnement.
- Préparer un App Service Dev et éventuellement un App Service Staging.
- Préparer un endpoint `/health`.

## Avant le jour 4

- Préparer un environnement `croissant-production` avec approval.
- Préparer un App Service avec slot staging si possible.
- Préparer un exemple de Variable Group.
- Préparer une explication simple de Key Vault.
- Préparer un scénario de rollback.

## Règles pédagogiques

1. Toujours partir d’un schéma avant le YAML.
2. Montrer peu de YAML au début.
3. Expliquer chaque mot : trigger, stage, job, step, artifact.
4. Faire répéter la différence CI/CD.
5. Ne pas chercher à tout faire tourner si l’infrastructure manque.
6. Préférer une bonne compréhension à une démo trop ambitieuse.
7. Garder la même application fil rouge pendant 4 jours.

## Phrases utiles

> La CI vérifie le code.

> Le CD livre une version validée.

> Un artefact est ce que l’on déploie.

> Les environnements sont les endroits où l’application tourne.

> On ne change pas le code entre staging et production, on change la configuration.

> La production doit être protégée par des règles techniques et parfois une validation humaine.

> Un rollback doit être prévu avant l’incident.

## Ce qu’il faut simplifier

Ne pas approfondir :

- Terraform ;
- RBAC complet ;
- Defender for DevOps ;
- agents self-hosted Docker ;
- AKS ;
- Canary détaillé.

Les garder comme ouverture :

> Ce sont des sujets d’industrialisation plus avancée.
