resource "helm_release" "argo_rollouts" {
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = "~> 2.37"
  namespace        = "argo-rollouts"
  create_namespace = true
}
