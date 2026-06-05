# Commandes utiles

## Docker local

```bash
npm test
docker build -t croissant-api:local .
docker run --rm -p 8080:8080 croissant-api:local
curl http://localhost:8080/health
```

## Azure CLI

```bash
az login
az account show
az group create --name rg-croissant-demo --location westeurope
az acr create --resource-group rg-croissant-demo --name croissantregistrydemo --sku Basic
az acr login --name croissantregistrydemo
```

## App Service settings

```bash
az webapp config appsettings set \
  --resource-group rg-croissant-demo \
  --name croissant-api-dev \
  --settings WEBSITES_PORT=8080 ENVIRONMENT_NAME=dev LOG_LEVEL=debug
```

## Slots

```bash
az webapp deployment slot create \
  --resource-group rg-croissant-demo \
  --name croissant-api-prod \
  --slot staging

az webapp deployment slot swap \
  --resource-group rg-croissant-demo \
  --name croissant-api-prod \
  --slot staging \
  --target-slot production
```
