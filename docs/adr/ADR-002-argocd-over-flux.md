# ADR-002: ArgoCD over Flux for GitOps

## Decision
Use ArgoCD as the GitOps engine instead of Flux.

## Reasoning
ArgoCD has a visual UI that makes it easy to see what is 
deployed, what is synced, and what has drifted from Git. 
This is genuinely useful when learning GitOps because you 
can see the reconciliation loop working in real time. The 
App-of-Apps pattern in ArgoCD lets a single root Application 
manage all other Applications — adding a new workload is 
just dropping a file in a folder. ArgoCD also has 
better documentation for first-time users.

## Tradeoffs
Flux is more lightweight and considered more GitOps-native 
by some teams since it has no server component — it runs 
entirely as Kubernetes controllers. ArgoCD's server adds 
operational overhead and is another thing to keep running. 
For a larger team or a more resource-constrained cluster, 
Flux would be worth evaluating.
