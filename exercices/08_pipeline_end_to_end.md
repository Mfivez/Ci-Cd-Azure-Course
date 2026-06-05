# Exercice 8 — Lire le pipeline complet end-to-end

Ouvrir le fichier :

```text
demos/pipelines/04-full-docker-first.yml
```

Répondre aux questions suivantes.

1. Quel événement déclenche le pipeline ?
2. Quel stage correspond à la CI ?
3. Où les tests sont-ils exécutés ?
4. Où l’image Docker est-elle construite et poussée ?
5. Quel tag est utilisé pour identifier l’image ?
6. Quel stage déploie l’image en staging ?
7. À quoi sert le smoke test ?
8. Quel environnement doit être protégé par une approbation ?
9. Quelle commande permet le swap vers la production ?
10. Comment ferait-on un rollback avec les slots ?

Compléter ensuite ce schéma :

```text
GitHub
  ↓
__________
  ↓
npm test
  ↓
__________
  ↓
Azure Container Registry
  ↓
__________
  ↓
Smoke test
  ↓
__________
  ↓
Production
```
