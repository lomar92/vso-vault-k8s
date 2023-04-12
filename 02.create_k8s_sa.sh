#!/bin/sh
set -o xtrace
#delete before creting
kubectl delete serviceaccount vault-auth
kubectl delete -f vault-auth-secret.yaml
kubectl delete -f CRB-vault-auth-service-account.yaml

#create service account for k8s auth method
#assign auth-delegator cluster role binding to Vault sa
kubectl apply -f CRB-vault-auth-service-account.yaml

#create secret for sa vault-auth -- required since k8s version 1.24+
kubectl apply -f vault-auth-secret.yaml