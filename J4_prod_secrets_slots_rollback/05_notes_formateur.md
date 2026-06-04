# J4 — Notes formateur

## Intention pédagogique

Le jour 4 donne la vision professionnelle sans aller trop loin dans l’expertise avancée.

Les participants doivent repartir avec cette idée :

> La production doit être protégée et le rollback doit être prévu.

## Points à marteler

- Un secret ne va jamais en clair dans Git.
- Une approval n’est pas un manque d’automatisation, c’est un contrôle.
- Un slot staging permet de tester avant de basculer.
- Le rollback est une stratégie, pas une improvisation.
- Le monitoring post-déploiement fait partie du CD.

## Pièges fréquents

### Trop détailler Key Vault

Rester au niveau :

```text
Key Vault = coffre-fort
Variable Group = pont possible avec le pipeline
```

### Trop détailler Blue/Green et Canary

Blue/Green avec slots suffit.

Canary peut être mentionné comme ouverture :

> Canary consiste à exposer progressivement une version à une partie des utilisateurs.

### Se perdre dans la sécurité complète

Ne pas entrer dans RBAC avancé.

Dire :

> Retenez surtout le principe du moindre privilège.

## Conclusion globale du cours

Faire redessiner le schéma complet par les participants.

Schéma final :

```text
Code
  ↓
CI
  ↓
Artefact
  ↓
CD Dev
  ↓
CD Staging
  ↓
Approval
  ↓
Slot staging
  ↓
Swap Prod
  ↓
Monitoring
  ↓
Rollback
```

## Phrase finale

> Le DevOps professionnel, ce n’est pas juste aller vite. C’est livrer souvent, avec confiance, sécurité et retour arrière possible.
