#!/bin/sh
set -o xtrace

#Deploy Secret Sync Operator 
kubectl delete -f vault-static-secret.yaml 
helm delete vault-secrets-operator

helm install vault-secrets-operator hashicorp/vault-secrets-operator --version 0.1.0-beta --values vault-operator-values.yaml

#Sync your Secret with secret-sync API 
kubectl apply -f vault-static-secret.yaml

#kubernetes secret output after sync
#k get secret secretkv -o yaml > secret.yaml   