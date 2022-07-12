# Elastic Search
### Flux Notes 
```
export GITHUB_TOKEN=""
(⎈ |kubernetes-admin@kubernetes:default)[11:40:00 ~]kubeadvocate@ mac$ flux bootstrap github --owner="pavan-kumar-99" --repository=medium-manifests --branch=elasticsearch --path=clusters/home-cluster --token-auth
► connecting to github.com
► cloning branch "elasticsearch" from Git repository "https://github.com/pavan-kumar-99/medium-manifests.git"
✔ cloned repository
► generating component manifests
✔ generated component manifests
✔ component manifests are up to date
► installing components in "flux-system" namespace
✔ installed components
✔ reconciled components
► determining if source secret "flux-system/flux-system" exists
► generating source secret
► applying source secret "flux-system/flux-system"
✔ reconciled source secret
► generating sync manifests
✔ generated sync manifests
✔ committed sync manifests to "elasticsearch" ("b824df0a4dc7a8f6e51738b95cf2daf76e06b0b8")
► pushing sync manifests to "https://github.com/pavan-kumar-99/medium-manifests.git"
► applying sync manifests
✔ reconciled sync configuration
◎ waiting for Kustomization "flux-system/flux-system" to be reconciled
✔ Kustomization reconciled successfully
► confirming components are healthy
✔ helm-controller: deployment ready
✔ kustomize-controller: deployment ready
✔ notification-controller: deployment ready
✔ source-controller: deployment ready
✔ all components are healthy

```
