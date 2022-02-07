#!/bin/bash

[ -z "$1" ] && echo "Need registry username." && exit 1
[ -z "$2" ] && echo "Need registry password." && exit 1

GREYMATTER_REGISTRY_USERNAME=$1
GREYMATTER_REGISTRY_PASSWORD=$2

printf "\nk3d cluster create -c k3d.yaml \n"
k3d cluster create -c k3d.yaml

printf "\nkubectl create namespace gm-operator --save-config \n"
kubectl create namespace gm-operator --save-config

printf "\nkubectl create secret docker-registry gm-docker-secret ... \n"
kubectl create secret docker-registry gm-docker-secret \
  --docker-server=docker.greymatter.io \
  --docker-username=$GREYMATTER_REGISTRY_USERNAME \
  --docker-password=$GREYMATTER_REGISTRY_PASSWORD \
  --docker-email=$GREYMATTER_REGISTRY_USERNAME \
  -n gm-operator

printf "\nkubectl apply -k ../operator/config/context/kubernetes  # https://github.com/greymatter-io/operator \n"
kubectl apply -k ../operator/config/context/kubernetes  # https://github.com/greymatter-io/operator
kubectl wait --for=condition=Ready pod -l name=gm-operator -n gm-operator
kubectl wait --for=condition=Ready pod -l app=agent -n spire

printf "\nkubectl apply -f mesh.yaml \n"
kubectl apply -f mesh.yaml

# deployment.yaml is applied seperately because the operator/mesh isn't ready to respond to the event?
# {"level":"error","ts":1644269838.709611,"logger":"k8sapi","msg":"update","Deployment":{"namespace":"fibonacci-namespace","name":"fibonacci-deployment"},"error":"Operation cannot be fulfilled on deployments.apps \"fibonacci-deployment\": the object has been modified; please apply your changes to the latest version and try again"}
printf "\nkubectl apply -f deployment.yaml \n"
kubectl apply -f deployment.yaml

printf "\ngo run checktime.go \n"
go run checktime.go
