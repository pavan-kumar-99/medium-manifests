#!/bin/bash


## Adding the Official Grafana Helm Repo 

helm repo add grafana https://grafana.github.io/helm-charts


## Update the helm chart 

helm repo update


## Install helm chart with the following Stack enabled ( Loki, Promtail, Grafana, Prometheus )

helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false
