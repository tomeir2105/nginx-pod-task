# K3s Nginx Shared Folder Deployment

This project deploys a 3-replica Nginx web server in K3s, serving files from a hostPath PVC.

## What i learned in this task  
- using pv and pvc for creating a shared folder in the pod (PersistentVolume and PersistentVolumeClaim)
- how to use and setup configMap to work in the pod
- what are pod replicas and how to use them
- how to expose a port from the pod to the world using service
- how to apply the pod yaml with multi configurations and wait for the pods to load
- using rollout restart (no need to delete pods...)
  
## Setup

Run:

```bash
sudo chmod +x deploy.sh
./deploy.sh
```

## Cleanup
```bash
sudo chmod +x delete.sh
./delete.sh
```
