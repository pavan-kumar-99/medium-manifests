#!/bin/bash

### Loki Medium Logs sample deployment

kubectl create deploy loki-medium-logs --image=busybox -- sh -c 'for run in $(seq 1 10000); do echo "Hello $run"; sleep 2; done'

