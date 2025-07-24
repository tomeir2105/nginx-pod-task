# K3s Nginx Shared Volume Deployment

## Task Overview

The task targets are:
- Share a folder from the host with K3s using a `hostPath` volume
- Create a `PersistentVolume` and `PersistentVolumeClaim`
- Deploy an Nginx server using that PVC
- Configure Nginx to:
  - Serve an `index.html` file
  - Provide directory listing under `/files`
- Expose the service using a `NodePort`
- Automate everything with a single deploy script

## Shared Folder Content

- `/mnt/k3s-share/index.html` — displays banner and link to `/files`
- `/mnt/k3s-share/files/` — shared directory to browse/download files

## Kubernetes Components

- `PersistentVolume` using `hostPath`
- `PersistentVolumeClaim` with `ReadWriteMany`
- `ConfigMap` to override Nginx to use port `1234` and show `/files`
- `Deployment` of 3 Nginx replicas
- `Service` with `NodePort` (`31234`)
