#!/bin/bash

# Vérifier le nombre d'arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 IP ACCESS_TOKEN NOM_DE_DOMAINE ENV_PREFIX"
	echo "Exemple : 10.2.14.243 AokdozkdOSDKdoskd froissant.work qa"
  exit 1
fi

IP="$1"
ACCESS_TOKEN="$2"
DOMAINE_NAME="$3"
ENV_PREFIX="$4"
URL="https://api.gandi.net/v5/livedns/domains/${DOMAINE_NAME}/records/*.${ENV_PREFIX}.gr1"

# Fonction pour effectuer la requête
make_request() {
  local method="$1"
  local data="$2"

  local response
  response=$(curl -s -X "$method" -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" -d "$data" -w "\n%{http_code}" "$URL")
	
  local status
  status=$(echo "$response" | tail -n 1)

  # Vérifier le code de statut
  if [ "$status" -eq 201 ]; then
    echo "Opération réussie."
    exit 0
  else
    echo "Opération échouée. Code de statut : $status"
    exit 1
  fi
}

# Effectuer la requête GET
response=$(curl -s -X GET -H "Authorization: Bearer ${ACCESS_TOKEN}" "$URL")

# Vérifier si le tableau est vide
if [[ "$response" == *"[]"* ]]; then
  # Faire une requête POST
  data='{"rrset_type": "A", "rrset_values": ["'"${IP}"'"], "rrset_ttl": 300}'
  make_request "POST" "$data"
else
  # Faire une requête PUT
	data='{
		"items": [
			{
				"rrset_type": "A",
				"rrset_values": ["'"${IP}"'"],
				"rrset_ttl": 300
			}
		]
	}'
  make_request "PUT" "$data"
fi
