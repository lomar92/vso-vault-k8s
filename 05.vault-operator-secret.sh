#!/bin/sh
set -o xtrace

#Deploy Secret Sync Operator 
kubectl delete -f static-secret.yaml 
helm delete vault-secrets-operator

helm install vault-secrets-operator hashicorp/vault-secrets-operator --version 0.1.0-beta --values vault-operator-values.yaml

#Sync your Secret with secret-sync API 
kubectl apply -f static-secret.yaml