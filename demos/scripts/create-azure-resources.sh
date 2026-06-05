#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-croissant-demo}"
LOCATION="${LOCATION:-westeurope}"
NAME_PREFIX="${NAME_PREFIX:-croissantdemo$RANDOM}"

az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "../infra/main.bicep" \
  --parameters namePrefix="$NAME_PREFIX"

cat <<EOF
Ressources créées.
Resource Group : $RESOURCE_GROUP
Préfixe        : $NAME_PREFIX

Pense à créer les Service Connections Azure DevOps :
- sc-acr-croissant
- sc-azure-croissant
EOF
