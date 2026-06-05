# Exercice 6 — Comprendre slots et rollback

Situation initiale :

```text
production : v1
staging    : vide
```

Le pipeline déploie v2 sur staging.

1. Représenter l’état avant le swap.
2. Représenter l’état après le swap.
3. Un bug critique est détecté sur v2. Que faire pour revenir à v1 ?
4. Pourquoi le rollback est plus rapide avec un slot qu’avec une reconstruction complète ?
