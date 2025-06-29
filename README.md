# DemoApp – 3-tier Cloud-Native Application on Azure

This project demonstrates a 3-tier architecture:
- **Frontend:** Static website hosted in Azure Storage
- **Backend:** Node.js application running in AKS
- **Database:** MySQL (either as a container in AKS or as Azure Database for MySQL PaaS)

![Architecture Diagram](img/diagram.png)

## Folder Structure

```
backend/      # Node.js backend (Dockerfile, package.json, etc.)
terraform/    # Terraform code for Azure Storage and other resources
kubernetes/   # Kubernetes manifests (deployments, services, ingress, cert-manager, etc.)
```