#!/usr/bin/env bash -eox pipefail
manifestsPath=$(pwd)/manifests
. "$(pwd)/scripts/seed_variables.sh"

lego \
--path=$certPath \
--email="$certEmail" \
--domains="*.$baseDomain" \
--dns="cloudflare" \
run

kubectl create secret generic traefik-public-certs --from-file="$certPath/certificates/_.$baseDomain.crt" \
--from-file="$certPath/certificates/_.$baseDomain.key"

kubectl build ${manifestsPath}/traefik/${networkName} | kubectl apply -f -

kustomize build ${manifestsPath}/bns/${networkName} | kubectl apply -f -

# experimental: set DNS records
# public traefik
set +e
IP=$(kubectl get service traefik-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
while [ "$IP" == "" ]; do
    sleep 5
    IP=$(kubectl get service traefik-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
done
set -e

ZONE_ID="81cd28da6edc47e3b688757f8466163e"; \
EMAIL="$CLOUDFLARE_EMAIL"; \
KEY="$CLOUDFLARE_API_KEY"; \
DOMAIN="$ROOT_DOMAIN"; \
TYPE="A"; \
NAME="*.$baseDomain"; \
CONTENT="$IP"; \
PROXIED="false"; \
TTL="1"; \
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/" \
    -H "X-Auth-Email: $EMAIL" \
    -H "X-Auth-Key: $KEY" \
    -H "Content-Type: application/json" \
    --data '{"type":"'"$TYPE"'","name":"'"$NAME"'","content":"'"$CONTENT"'","proxied":'"$PROXIED"',"ttl":'"$TTL"'}'

set +e