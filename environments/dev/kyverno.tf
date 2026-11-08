# Kyverno is the admission controller that refuses unsigned images.
# Chart 3.9.x deploys Kyverno 1.19.x.
resource "helm_release" "kyverno" {
  name             = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = "~> 3.9"
  namespace        = "kyverno"
  create_namespace = true
  timeout          = 600

  # Only the admission controller is needed to verify images. The cleanup and
  # reports controllers are switched off to save CPU and memory on a small
  # local cluster that already runs ArgoCD and monitoring.
  values = [<<-YAML
    cleanupController:
      enabled: false
    reportsController:
      enabled: false
  YAML
  ]
}
