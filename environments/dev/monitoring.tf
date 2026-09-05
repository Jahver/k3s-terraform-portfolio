resource "helm_release" "monitoring" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "~> 65.5"
  namespace        = "monitoring"
  create_namespace = true
  timeout          = 600

  values = [<<-YAML
    alertmanager:
      enabled: false

    grafana:
      adminPassword: "admin123"
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi

    prometheus:
      prometheusSpec:
        retention: 6h
        resources:
          requests:
            cpu: 150m
            memory: 256Mi
          limits:
            cpu: 300m
            memory: 512Mi

    prometheusOperator:
      resources:
        requests:
          cpu: 50m
          memory: 128Mi

    kube-state-metrics:
      resources:
        requests:
          cpu: 50m
          memory: 64Mi
  YAML
  ]
}
