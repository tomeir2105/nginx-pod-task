#!/bin/bash
#############################################
# Created by Meir on 24/7
# This script:
#  - Checks K3s is installed and running
#  - Creates a shared folder with index.html
#  - Deploys Nginx with PVC using K3s
#  - Exposes the shared folder via browser
#############################################

SHARE_PATH="/mnt/k3s-share"
INDEX_FILE="$SHARE_PATH/index.html"

# Check if K3s is installed and running
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found. Please install K3s"
  exit 1
fi

if ! kubectl get nodes &> /dev/null; then
  echo "K3s is not responding."
  exit 1
fi

# Create folder and HTML
sudo mkdir -p "$SHARE_PATH/files"

sudo tee "$INDEX_FILE" > /dev/null <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>NFS StorageClass To Container</title>
</head>
<body>
  <h1>NFS StorageClass To Container</h1>
  <p><a href="/files/">Browse shared files</a></p>
</body>
</html>
EOF

echo "test file" | sudo tee "$SHARE_PATH/files/test.txt" > /dev/null
sudo chmod -R 777 "$SHARE_PATH"

# Apply Kubernetes resources
kubectl apply -f nginx-deploy.yaml
kubectl rollout restart deployment nginx

echo "Waiting for all Nginx pods to start"
kubectl wait --for=condition=ready pod -l app=nginx --timeout=60s > /dev/null

echo
echo "Final running Nginx pods:"
kubectl get pods -l app=nginx --field-selector=status.phase=Running --no-headers | head -n 3

echo
echo "Deployment complete."
echo "Access web site: http://localhost:31234/"
echo "Enter a pod: kubectl exec -it <pod-name> -- /bin/sh"

