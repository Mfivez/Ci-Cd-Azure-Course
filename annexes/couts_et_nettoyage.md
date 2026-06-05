# Coûts et nettoyage

Les ressources Azure peuvent générer des coûts. Pour une démo, rester simple :

- ACR en SKU Basic.
- App Service Plan de petite taille.
- Pas de base de données payante.
- Pas de VM.
- Pas d’AKS.

Après la démo, supprimer le Resource Group :

```bash
az group delete --name rg-croissant-demo --yes --no-wait
```

Vérifier dans le portail Azure que les ressources ont bien disparu.
