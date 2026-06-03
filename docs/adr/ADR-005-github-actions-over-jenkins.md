# ADR-005: GitHub Actions over Jenkins for CI

## Decision
Use GitHub Actions for CI pipelines instead of Jenkins.

## Reasoning
GitHub Actions is native to the repository — no extra 
infrastructure to provision or maintain. Jenkins requires 
running and operating a Jenkins server, which is additional 
cost and complexity on top of everything else the platform 
already manages. GitHub Actions workflows are YAML files 
committed to the repo alongside the code they validate, 
which fits naturally into the GitOps model. The combination 
of GitHub Actions for CI and ArgoCD for CD is a modern, 
widely-used pattern at companies doing cloud-native 
development.

## Tradeoffs
Jenkins is more flexible and has a larger plugin ecosystem. 
For complex pipelines with many custom steps, Jenkins gives 
you more control. Jenkins is also self-hosted, which means 
build logs and artifacts stay within your own infrastructure 
— relevant for organisations with strict data compliance 
requirements. For this project those concerns don't apply.
