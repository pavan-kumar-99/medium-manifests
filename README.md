Vault-k8s is a Kubernetes integration that enables applications with no native HashiCorp Vault logic built-in to leverage static and dynamic secrets sourced from Vault.This leverages the Kubernetes Mutating Admission Webhook to intercept and augment specifically annotated pod configuration for secrets injection using Init and Sidecar containers.
