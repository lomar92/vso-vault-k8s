#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:30000
export VAULT_TOKEN=root

vault secrets enable -path=kvv2 kv-v2

vault kv put kvv2/webapp/config username="static-user" password="static-password"

vault kv get kvv2/webapp/config
