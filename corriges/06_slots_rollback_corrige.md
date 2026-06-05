# Corrigé 6 — Comprendre slots et rollback

Avant le swap :

```text
production : v1
staging    : v2
```

Après le swap :

```text
production : v2
staging    : v1
```

Si v2 pose problème, on refait un swap inverse.

```text
production : v1
staging    : v2
```

Le rollback est plus rapide, car l’ancienne version existe déjà sur le slot staging. On ne doit pas reconstruire une image ni refaire tout le processus de build.
