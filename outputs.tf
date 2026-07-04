output "cluster_name" {
  description = "Name of the kind cluster"
  value       = kind_cluster.platform.name
}

output "kubeconfig_path" {
  description = "Path to the generated kubeconfig"
  value       = kind_cluster.platform.kubeconfig_path
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = kind_cluster.platform.endpoint
}

output "get_nodes_command" {
  description = "Run this to confirm the cluster is up"
  value       = "KUBECONFIG=${kind_cluster.platform.kubeconfig_path} kubectl get nodes"
}
