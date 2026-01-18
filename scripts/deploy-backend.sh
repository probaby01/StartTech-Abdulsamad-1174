#!/bin/bash
set -e

echo "Building Docker image..."
cd Server/MuchToDo
docker build -t muchtodo-backend:latest .

echo "Tagging image..."
docker tag muchtodo-backend:latest $ECR_REGISTRY/muchtodo-backend:latest

echo "Pushing to ECR..."
docker push $ECR_REGISTRY/muchtodo-backend:latest

echo "Backend deployment complete!"