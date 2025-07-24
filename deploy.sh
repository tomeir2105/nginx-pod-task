#!/bin/bash
#############################################
# Created by Meir on 24/7
# This script:
#  - Checks K3s is installed and running
#  - Sets up NFS server on host if needed
#  - Creates a shared folder with index.html
#  - Deploys Nginx with PVC using K3s
#  - Exposes the shared folder via browser
#############################################

NFS_DIR="/srv/nfs/k3s-share"
INDEX_FILE="$NFS_DIR/index.html"

# Check if K3s is installed and running
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found. Please install K3s"
  exit 1
fi

if ! kubectl get nodes &> /dev/null; then
  echo "K3s is not responding."
  exit 1
fi

# Set up NFS server if not installed
if ! dpkg -s nfs-kernel-server &> /dev/null; then
  echo "Installing NFS server..."
  sudo apt update
  sudo apt install -y nfs-kernel-server
fi

# Create export directory
sudo mkdir -p "$NFS_DIR/files"
sudo chmod -R 777 "$NFS_DIR"

# Add export rule if not present
EXPORT_LINE="$NFS_DIR *(rw,sync,no_subtree_check,no_root_squash)"
if ! grep -qF "$EXPORT_LINE" /etc/exports; then
  echo "$EXPORT_LINE" | sudo tee -a /etc/exports
  sudo exportfs -rav
fi

# Create index.html
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

# Test file
echo "test file" | sudo tee "$NFS_DIR/files/test.txt" > /dev/null

# Apply Kubernetes NFS deployment
kubectl apply -f nginx-nfs-deploy.yaml
kubectl rollout restart deployment nginx

echo "Waiting for all Nginx pods to be fully ready..."
kubectl wait --for=condition=ready pod -l app=nginx --timeout=60s > /dev/null

echo
echo "Final running Nginx pods:"
kubectl get pods -l app=nginx --field-selector=status.phase=Running --no-headers | head -n 3

echo
echo "Deployment complete."
echo "Access web site: http://localhost:31234/"
echo "Enter a pod: kubectl exec -it <pod-name> -- /bin/sh"
