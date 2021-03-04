#!/bin/bash
for i in {1..100000}; do
curl -X POST -d name=$i http://192.168.29.165:8080 
done
