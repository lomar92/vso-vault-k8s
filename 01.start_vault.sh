#!/bin/sh
set -o xtrace
#Delete stuff
helm delete vault

helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm search repo hashicorp/vault -l

helm install vault hashicorp/vault --values vault-helm-values.yaml
k delete sa vault 
