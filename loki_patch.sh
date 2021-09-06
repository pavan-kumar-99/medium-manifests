#!/bin/bash

###Accessing Grafana via a Load Balancer

kubectl patch svc loki-grafana -p '{"spec": {"type": "LoadBalancer"}}'


###Getting the Load Balancer IP

kubectl get svc loki-grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}'


###Getting the admin username and Password

kubectl get secret loki-grafana -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
