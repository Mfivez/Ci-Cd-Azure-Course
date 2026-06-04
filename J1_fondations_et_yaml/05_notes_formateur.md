# J1 — Notes formateur

## Intention pédagogique

Le jour 1 doit rassurer. Les participants doivent comprendre les mots avant de voir des pipelines complexes.

Ne pas chercher à impressionner avec trop de YAML.

## Erreurs fréquentes des participants

### Confondre CI et CD

Réponse simple :

```text
CI = vérifier
CD = livrer
```

### Penser qu’un environnement est une branche

Réponse :

> Une branche est une version du code. Un environnement est un endroit où l’application tourne.

### Se perdre dans Azure DevOps

Rappeler :

> Aujourd’hui, on ne visite pas toute la plateforme. On se concentre sur Pipelines.

### Avoir peur du YAML

Montrer la structure comme une hiérarchie :

```text
stage
  job
    step
```

## À surveiller

- Les participants comprennent-ils la différence stage/job/step ?
- Savent-ils lire un log de pipeline ?
- Savent-ils expliquer pourquoi un pipeline rouge est utile ?

## Phrase de clôture

> Aujourd’hui, on a compris le vocabulaire et la forme d’un pipeline. Demain, on rend ce pipeline utile : il va installer, tester, builder et produire un artefact.
