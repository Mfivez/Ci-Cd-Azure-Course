# J3 — Notes formateur

## Intention pédagogique

Le jour 3 doit faire passer du monde CI au monde CD sans aller trop vite vers la production.

Les participants doivent comprendre :

```text
On récupère l’artefact → on choisit un environnement → on déploie → on vérifie
```

## Points à marteler

> Le CD ne reconstruit pas, il déploie.

> Même artefact, configuration différente.

> Un environnement n’est pas une branche.

> Un smoke test n’est pas une suite de tests complète, c’est un contrôle rapide.

## Démo réelle ou simulation

Si Azure App Service n’est pas prêt, utiliser :

```yaml
- script: echo "Deploy Dev"
```

Puis expliquer où serait la tâche `AzureWebApp@1`.

C’est mieux qu’une démo cassée.

## Pièges fréquents

### Vouloir aller jusqu’à la prod trop tôt

Dire :

> Aujourd’hui on construit la chaîne jusqu’à Staging. Demain on parlera des protections production.

### Trop de détails Azure

Ne pas expliquer tout Azure. Se limiter à :

- Resource Group ;
- App Service ;
- Application Settings ;
- Service Connection.

## Transition vers le jour 4

Phrase de clôture :

> Nous savons déployer en Dev et Staging. La production demande plus de prudence : approval, secrets, slots, rollback et monitoring.
