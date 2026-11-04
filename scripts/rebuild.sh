#!/usr/bin/env bash
# Rebuild the whole platform from nothing: kind cluster, ArgoCD, Argo Rollouts
# and monitoring (all from Terraform), then register the ArgoCD applications.
# Needs Docker, Terraform, kubectl and kind (the Codespaces devcontainer has them).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root/environments/dev"

echo "==> Creating cluster and installing ArgoCD, Argo Rollouts, monitoring"
terraform init -input=false
terraform apply -input=false -auto-approve

KUBECONFIG="$(terraform output -raw kubeconfig_path)"
export KUBECONFIG

echo "==> Waiting for nodes and ArgoCD"
kubectl wait --for=condition=Ready nodes --all --timeout=300s
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s

echo "==> Registering ArgoCD applications"
kubectl apply \
  -f guestbook-app.yaml \
  -f hello-app-argocd.yaml \
  -f "$repo_root/task-api-argocd.yaml"

echo "==> Waiting for task-api to sync and become healthy"
# ArgoCD needs a moment to create the Application status before wait can see it.
sleep 10
kubectl -n argocd wait --for=jsonpath='{.status.sync.status}'=Synced \
  application/task-api --timeout=300s
kubectl -n argocd wait --for=jsonpath='{.status.health.status}'=Healthy \
  application/task-api --timeout=600s

cat <<MSG

Done. Use this cluster with:
  export KUBECONFIG=$KUBECONFIG
  kubectl get nodes
  kubectl -n task-api get rollout

ArgoCD UI:   kubectl -n argocd port-forward svc/argocd-server 8080:80
Grafana UI:  kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80
MSG
