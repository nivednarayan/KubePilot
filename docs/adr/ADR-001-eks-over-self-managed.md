# ADR-001: AWS EKS over self-managed Kubernetes

## Decision
Use AWS EKS as the Kubernetes platform instead of 
self-managing the control plane with kops or k3s.

## Reasoning
The control plane — API server, etcd, scheduler — is the 
most complex part of Kubernetes to operate. Managing it 
yourself means handling HA, upgrades, certificate rotation, 
and etcd backups. EKS handles all of this. The goal of this 
project is to learn how to operate workloads on Kubernetes, 
not how to operate Kubernetes itself. EKS also integrates 
natively with AWS IAM via IRSA, which lets pods get AWS 
permissions without static credentials.

## Tradeoffs
EKS costs $0.10/hour for the control plane regardless of 
whether anything is running. It also introduces AWS vendor 
lock-in — IRSA and the AWS Load Balancer Controller are 
AWS-specific. On another cloud you would need equivalent 
managed services (GKE on GCP, AKS on Azure).
