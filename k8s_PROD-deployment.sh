#!/bin/bash

#k8s-deployment.sh

istioURL=$(echo ${prodApplicationURL} | sed -E 's/^\s*.*:\/\///g')

echo ${istioURL}

sed -i "s#DEPLOY_IMAGE#${imageName}#g" k8s_PROD-deployment_service.yaml
sed -i "s#BASE_URL#${baseURL}#g" k8s_PROD-deployment_service.yaml
sed -i "s#PROD_WEBSITE_URL#${istioURL}#g" k8s_PROD-deployment_service.yaml

kubectl -n ${prodNamespace} apply -f k8s_PROD-deployment_service.yaml
