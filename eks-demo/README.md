# Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster), containing
Terraform configuration files to provision an EKS cluster on AWS.

After deployment, obtain EKS credentials:
aws eks --region <REGION> update-kubeconfig --name <EKS CLUSTER NAME>
