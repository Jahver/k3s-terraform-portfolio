# A local multi-node Kubernetes cluster using kind (Kubernetes-in-Docker).
# Each "node" is a Docker container, so a 3-node cluster costs nothing
# beyond the RAM/CPU already on your machine — no cloud account, no card,
# no free-tier ceiling to worry about.
resource "kind_cluster" "platform" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role  = "control-plane"
      image = "kindest/node:${var.kubernetes_version}"
    }

    dynamic "node" {
      for_each = range(var.worker_count)
      content {
        role  = "worker"
        image = "kindest/node:${var.kubernetes_version}"
      }
    }
  }
}
