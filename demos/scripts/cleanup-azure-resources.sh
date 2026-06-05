#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-croissant-demo}"

az group delete \
  --name "$RESOURCE_GROUP" \
  --yes \
  --no-wait

echo "Suppression demandée pour $RESOURCE_GROUP."
