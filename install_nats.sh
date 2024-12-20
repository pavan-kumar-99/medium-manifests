#!/bin/bash

NATS_HELM_REPO_URL="https://nats-io.github.io/k8s/helm/charts"
NATS_HELM_RELEASE_NAME="nats"
NATS_NAMESPACE="nats"

helm repo add nats $NATS_HELM_REPO_URL
helm repo update
helm install $NATS_HELM_RELEASE_NAME nats/nats \
  --namespace $NATS_NAMESPACE --create-namespace \
  --set config.cluster.enabled=true \
  --set config.jetstream.enabled=true

echo "NATS Helm installation is complete."
