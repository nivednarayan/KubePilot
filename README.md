# Kube-Pilot

A production-grade Kubernetes platform on AWS that lets you deploy, 
observe, and scale your applications securely — bootstrapped from 
zero with a single script.

## Overview

KubePilot is a platform you can use to deploy your app on Kubernetes 
in a fully observable, scalable, and secure way. Instead of manually 
running kubectl commands and clicking around in the AWS console, 
KubePilot gives you a single bootstrap script that provisions your 
entire AWS infrastructure, sets up GitOps delivery, deploys a full 
observability stack, and enforces security policies — automatically.

The difference from just using kubectl: with kubectl you apply 
manifests manually, there's no audit trail, no automatic scaling, 
no visibility into what's running, and no security guardrails. 
KubePilot solves all of that out of the box.

## Architecture

```
Your Laptop
    │
    ├── terraform apply → AWS (VPC + EKS + IAM)
    │
    └── git push → ArgoCD → Kubernetes Cluster
                                │
                    ┌───────────┼───────────┐
                    │           │           │
               Prometheus    Kyverno       App
               Grafana       Policies     (HPA)
               Loki
```

## Stack

| Component | Purpose |
|---|---|
| Terraform | Provisions all AWS infrastructure as code |
| AWS EKS | Managed Kubernetes control plane |
| ArgoCD | GitOps engine — cluster always matches Git |
| Prometheus | Metrics collection from every pod and node |
| Grafana | Real-time dashboards and alerting |
| Loki | Centralized log aggregation |
| Kyverno | Admission control — enforces security policies |
| HPA | Auto-scales pods based on CPU usage |
| GitHub Actions | CI pipeline — validates Terraform and Helm on every PR |
| Metrics Server | Enables HPA to read resource metrics |

## Reference Workload

A reference application is included at `platform/workloads/demo-app/` 
to demonstrate platform capabilities:

- Runs as non-root (compliant with Kyverno policies)
- CPU and memory limits set
- Liveness and readiness probes configured
- HPA configured to scale between 1-5 pods at 50% CPU threshold

To deploy your own application, follow the same structure:
1. Add your Kubernetes manifests to `platform/workloads/your-app/`
2. Create an ArgoCD Application at `platform/apps/your-app.yaml` 
   pointing to that folder
3. Push to Git — ArgoCD deploys it automatically

Your workload must comply with the Kyverno policies or it will 
be rejected at deploy time.

## Prerequisites

- AWS account with credentials configured (`aws configure`)
- Terraform >= 1.6 installed
- kubectl installed
- ArgoCD CLI installed
- Git

## Quickstart

```bash
git clone https://github.com/nivednarayan/KubePilot
cd KubePilot
./scripts/bootstrap.sh
```

Once the script completes (about 15-20 minutes), access the UIs:

```bash
# ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8085:443
# Open https://localhost:8085
# Username: admin
# Password: kubectl -n argocd get secret argocd-initial-admin-secret \
#   -o jsonpath="{.data.password}" | base64 -d

# Grafana
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
# Open http://localhost:3000
# Username: admin / Password: set in platform/apps/prometheus-app.yaml under grafana.adminPassword
```

To tear everything down:

```bash
./scripts/teardown.sh
```

## Project Structure

```
kube-pilot/
├── infra/
│   └── terraform/
│       ├── modules/
│       │   ├── vpc/        ← VPC, subnets, IGW, NAT
│       │   └── eks/        ← EKS cluster, node groups, IRSA
│       ├── backend.tf      ← S3 remote state
│       ├── providers.tf    ← AWS + TLS providers
│       └── variables.tf    ← Input variables
├── platform/
│   ├── argocd/             ← ArgoCD install config + AppProject
│   ├── apps/               ← ArgoCD Application manifests (App-of-Apps)
│   └── workloads/          ← Actual Kubernetes manifests
│       ├── demo-app/       ← Demo workload with HPA
│       ├── kyverno-policies/← Security policies
│       └── monitoring-config/← Grafana datasource configs
├── scripts/
│   ├── bootstrap.sh        ← One-command cluster setup
│   └── teardown.sh         ← One-command destroy
├── docs/
│   └── adr/                ← Architecture Decision Records
└── .github/
    └── workflows/          ← CI pipelines
```

## Security

Kyverno enforces these policies on every workload at admission time:

- No containers running as root
- All containers must declare CPU and memory limits
- No privileged containers
- Liveness and readiness probes required
- App label required on all pods

Violating any policy causes the deployment to be rejected with a 
clear error before anything runs.

## Cost

Running 4 hours/day with daily destroy:

| Resource | Monthly cost |
|---|---|
| EKS control plane | ~$10 |
| EC2 nodes (2x t3.medium) | ~$8 |
| NAT Gateway | ~$6 |
| Everything else | ~$2 |
| **Total** | **~$26/month** |

## Limitations

- Runs on a single AWS region — production would be multi-region
- Bootstrap requires manual steps for Prometheus CRDs — 
  automating this properly is a planned improvement
- No service mesh (Istio/Linkerd) — traffic management is at 
  the pod level only
- cert-manager and External DNS configured but require a 
  domain name
  
## Author

Nived Narayan — B.Tech CSE (AI & DS), IIIT Kottayam (2024-2028)

[GitHub](https://github.com/nivednarayan) · 
[LinkedIn](https://linkedin.com/in/nived-narayan)

