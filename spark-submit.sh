#!/bin/bash

./spark-submit \
  --master k8s://https://789D6D607C4972ED2CA083E2AF899941.gr7.ap-south-1.eks.amazonaws.com \
  --deploy-mode cluster \
  --name spark-pi \
  --class org.apache.spark.examples.SparkPi \
  --conf spark.executor.instances=2 \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
  --conf spark.kubernetes.namespace=default \
  --conf spark.kubernetes.driver.request.cores=0.001 \
  --conf spark.driver.memory=1g \
  --conf spark.kubernetes.executor.request.cores=0.001 \
  --conf spark.executor.memory=1g \
   --conf spark.kubernetes.node.selector.nodegroup-type=spot \
  --conf spark.kubernetes.container.image=gcr.io/spark-operator/spark-py:v3.0.0 \
  local:///opt/spark/examples/src/main/python/pi.py
