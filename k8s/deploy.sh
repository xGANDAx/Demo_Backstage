#!/bin/bash

set -e

NAMESPACE=backstage
APP_NAME=backstage
IMAGE=$1

echo "🚀 Deploying $APP_NAME with image $IMAGE"

# 1. Aplicar recursos estáticos (solo si cambian)
echo "📦 Applying base resources (service, ingress...)"
kubectl apply -f k8s/manifests

# 2. Actualizar solo la imagen del deployment
echo "🔄 Updating deployment image"
kubectl get deployment $APP_NAME -n $NAMESPACE || kubectl apply -n $NAMESPACE -f k8s/deployment/deployment.yaml
kubectl set image deployment/$APP_NAME $APP_NAME=$IMAGE -n $NAMESPACE

# 3. Esperar rollout
echo "⏳ Waiting for rollout"
kubectl rollout status deployment/$APP_NAME -n $NAMESPACE

echo "✅ Deployment successful"