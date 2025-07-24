#!/bin/bash
#############################################
# Created by Meir on 24/7
# This script:
#  - Delete Nginx pod deployment
#############################################

kubectl delete deployment nginx
kubectl delete service nginx-service
kubectl delete configmap nginx-custom-config

echo "to remove the shared folder use:"
echo "  sudo rm -rf /mnt/k3s-share"

