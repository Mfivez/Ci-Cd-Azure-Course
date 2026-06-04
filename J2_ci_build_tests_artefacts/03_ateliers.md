# J2 — Ateliers

## Atelier 1 — Compléter un pipeline CI

Compléter les étapes manquantes :

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '20.x'

  # TODO installer les dépendances

  # TODO lancer les tests

  # TODO lancer le build
```

## Atelier 2 — Ajouter un artefact

À partir du pipeline précédent, ajouter :

1. une étape qui crée un ZIP ;
2. une étape qui publie l’artefact sous le nom `drop`.

## Atelier 3 — Analyser un pipeline rouge

Scénario :

```text
Le pipeline échoue sur npm test.
```

Questions :

1. Est-ce un problème de CI ou de CD ?
2. Faut-il quand même produire un artefact ?
3. Faut-il déployer ?
4. Où chercher l’erreur ?

## Atelier 4 — Branch policy

Choisir les règles minimales pour protéger `main` :

```text
A. minimum 1 reviewer
B. build validation obligatoire
C. push direct autorisé
D. Work Item obligatoire
E. force push autorisé
```

## Atelier 5 — Mini quiz

1. Un artefact doit être produit avant les tests. Vrai ou faux ?
2. `Build.ArtifactStagingDirectory` sert à préparer le contenu à publier. Vrai ou faux ?
3. Build Once Deploy Everywhere veut dire reconstruire à chaque environnement. Vrai ou faux ?
4. Une CI réussie garantit que la production ne cassera jamais. Vrai ou faux ?
5. Une Branch Policy peut obliger un build vert avant merge. Vrai ou faux ?
