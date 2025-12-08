## This repository contains Infrastructure-as-Code (IaC) using **Terraform** to provision an **Amazon EKS Cluster**, and a **Jenkins CI/CD pipeline** that builds Docker images, pushes them to AWS ECR, and deploys applications to EKS.


## Prerequisites
You must have installed:

- AWS Account (Free Tier)  
- AWS CLI
- Terraform 
- kubectl  
- Docker  
- Jenkins with plugins:  
  - Pipeline  
  - Docker Pipeline  
  - Amazon ECR  
  - Kubernetes CLI  

## Terraform Deployment Steps

### 1. Initialize

```sh
terraform init
```

## Validate

```sh
terraform validate
```

## Plan

```sh
terraform plan
```

## Apply

```sh
terraform apply --auto-approve
```

## Configure kubectl

```sh
aws eks update-kubeconfig --region <region> --name <cluster_name>
```

## Verify Connection

```sh
kubectl get nodes
kubectl get pods -A
```

![Website Screenshot](assets/Screenshot%202025-12-08%20174904.png)


## Verify VPC
![Website Screenshot](assets/Screenshot%202025-12-08%20175205.png)

## Verify Cluster
![Website Screenshot](assets/Screenshot%202025-12-08%20175124.png)

## Verify Manage nodes
![Website Screenshot](assets/Screenshot%202025-12-08%20175139.png)
