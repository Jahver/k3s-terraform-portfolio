provider "kubernetes" {
  host                   = kind_cluster.platform.endpoint
  cluster_ca_certificate = kind_cluster.platform.cluster_ca_certificate
  client_certificate     = kind_cluster.platform.client_certificate
  client_key             = kind_cluster.platform.client_key
}

provider "helm" {
  kubernetes {
    host                   = kind_cluster.platform.endpoint
    cluster_ca_certificate = kind_cluster.platform.cluster_ca_certificate
    client_certificate     = kind_cluster.platform.client_certificate
    client_key             = kind_cluster.platform.client_key
  }
}
