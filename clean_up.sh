#!/bin/bash

## Delete loki helm chart
helm delete loki


#### Delete the sample deployment 

kubectl delete deploy loki-medium-logs
