#!/bin/bash

creation_rules:
        - path_regex: prod/*
          hc_vault_transit_uri: "http://192.168.29.186:8200/v1/sops/keys/firstkey"
destination_rules:
   - vault_path: "sops/"
     vault_kv_mount_name: "kv/" # default
     vault_kv_version: 2 # default
     path_regex: prod/*
     omit_extensions: true

sops --hc-vault-transit http://192.168.29.186:8200/v1/sops/keys/firstkey vault_example.yml

gcloud kms keys add-iam-policy-binding \
  sops-key --location global --keyring sops \
  --member  owner-334@sodium-ceremony-309416.iam.gserviceaccount.com \
  --role roles/cloudkms.cryptoKeyEncrypterDecrypter

  cryptoKeyVersions.useToEncrypt

gcloud kms keys add-iam-policy-binding \
  sops-key --location global --keyring sops \
  --member devops.kumar@gmail.com \
  --role roles/cloudkms.cryptoKeyVersions.useToEncrypt


