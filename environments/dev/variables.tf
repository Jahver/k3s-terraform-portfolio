variable "cluster_name" {
  description = "Name of the local kind cluster"
  type        = string
  default     = "k3s-platform-dev"
}

variable "worker_count" {
  description = "Number of worker nodes (in addition to the control-plane node). Local Docker containers, so this costs nothing extra."
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Kubernetes version image tag for kind nodes"
  type        = string
  default     = "v1.30.0"
}
