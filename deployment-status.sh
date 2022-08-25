#!/bin/bash
if ! kubectl get namespace ari-ochoa; then
    kubectl create namespace ari-ochoa
fi

if ! kubectl rollout status deployment sample-spring-boot -n ari-ochoa; then
    kubectl apply -f kubernetes.yml
fi