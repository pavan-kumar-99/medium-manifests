#!/bin/bash
send_service=$(kubectl get svc send-service-rabbitmq-helm -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
for i in {1..10}; do
curl -X POST -d name=$i http://$send_service:8080 
done
