# K3s Nginx Shared Folder Deployment (NFS-backed)

This project deploys a 3-replica Nginx web server on a K3s cluster, serving files from a shared folder mounted via NFS (backed by a PersistentVolume and PersistentVolumeClaim).

## What I learned in this task

- How to create a shared folder on the host and serve it via NFS
- Using **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)** to provide shared storage
- Mounting PVC storage into containers
- Using **ConfigMap** to configure nginx ports and settings
- Understanding **replicas** and how to deploy multiple pods
- Exposing container ports to the outside world using **NodePort Services**
- Applying a Kubernetes manifest with multiple resources in a single YAML
- Waiting for pods to become ready using `kubectl wait`
- Restarting a deployment cleanly with `kubectl rollout restart`

## Setup

Run:

```bash
sudo chmod +x deploy.sh
./deploy.sh
```

This script will:
- Create the shared folder and test files
- Apply the NFS-based Kubernetes deployment
- Wait for pods to become ready
- Print status and access information

## Access

Once running, visit: [http://localhost:31234](http://localhost:31234)

## Cleanup

```bash
sudo chmod +x delete.sh
./delete.sh
```

This script will:
- Delete the Kubernetes deployment and related resources
- Optionally clean up the shared folder if needed
