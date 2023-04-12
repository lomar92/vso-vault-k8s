#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:30000
export VAULT_TOKEN=root


#create policy for the app to be able to access secrets
vault policy write dev dev-policy.hcl

#read vaules from the vault sa in k8s to wrtite the k8s auth config in vault

export VAULT_SA_NAME=$(kubectl get secrets --output=json \
    | jq -r '.items[].metadata | select(.name|startswith("vault-auth-")).name')
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME \
     -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME \
     -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_URL="https://kubernetes:443"

#enable k8s auth method

vault auth enable kubernetes

#configure with values extracted from the sa
vault write auth/kubernetes/config \
        token_reviewer_jwt="$SA_JWT_TOKEN" \
        kubernetes_host="$K8S_URL" \
        kubernetes_ca_cert="$SA_CA_CRT"

#create a new role role1, with ttl 24 hours

vault write auth/kubernetes/role/role1 \
        bound_service_account_names=vault-auth \
        bound_service_account_namespaces=default \
        policies=dev \
        audience=vault \
        ttl=24h