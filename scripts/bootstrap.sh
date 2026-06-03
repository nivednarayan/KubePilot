#!/bin/bash
set -e

echo "Applying infrastructure..."
cd infra/terraform && terraform apply -auto-approve && cd ../..

echo "Updating kubeconfig..."
aws eks update-kubeconfig --name kube-pilot-cluster --region us-east-1

echo "Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

echo "Applying Prometheus CRDs..."
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusagents.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

echo "Restoring ArgoCD state..."
kubectl apply -f platform/argocd/appproject.yaml
kubectl apply -f platform/argocd/apps/root-app.yaml

echo "Waiting for ArgoCD to sync..."
sleep 60

echo "Fixing Prometheus admission webhooks..."
kubectl delete mutatingwebhookconfiguration prometheus-kube-prometheus-admission 2>/dev/null || true
kubectl delete validatingwebhookconfiguration prometheus-kube-prometheus-admission 2>/dev/null || true
kubectl rollout restart deployment/prometheus-kube-prometheus-operator -n monitoring

echo "Bootstrap complete. Run the following to access:"
echo "ArgoCD:  kubectl port-forward svc/argocd-server -n argocd 8085:443"
echo "Grafana: kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80"
