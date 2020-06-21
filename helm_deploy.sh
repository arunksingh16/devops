#!/bin/bash

helm upgrade --install eck-test . --set clusterName=elasticsearch-test,KibanaClusterName=kibana-test --wait --timeout=30m -n dev

kubectl get pods -n dev -o json | jq -r '.items[].status.phase' | grep Pending 

helm test eck-test . --timeout 900

helm get values eck-test -n dev

helm status eck-test -n dev

helm history eck-test -n dev
