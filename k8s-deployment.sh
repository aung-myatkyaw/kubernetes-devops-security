#!/bin/bash

#k8s-deployment.sh

sed -i "s#DEPLOY_IMAGE#${imageName}#g" k8s_deployment_service.yaml
sed -i "s#BASE_URL#${baseURL}#g" k8s_deployment_service.yaml

kubectl -n ${devNamespace} apply -f k8s_deployment_service.yaml
