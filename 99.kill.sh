#!/bin/sh
set -o xtrace

helm delete vault
helm delete vault-secrets-operator

kubectl delete sa vault-auth
kubectl delete secret vault-auth 
kubectl delete -f vault-static-secret.yaml
kubectl delete -f CRB-vault-auth-service-account.yaml
kubectl delete secrets vso-cc-storage-hmac-key
kubectl delete -f secret.yaml
rm secret.yaml
