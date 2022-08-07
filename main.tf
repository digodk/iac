terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_digodk" {
  name   = var.k8s_name
  region = var.region

  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.23.9-do.0"

  node_pool {
    name       = "digodk"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "digodk-premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_digodk.id

  name       = "digodk-premium"
  size       = "s-2vcpu-4gb"
  node_count = 2

  labels = {
    service  = "backend"
    priority = "high"
  }
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_digodk.endpoint
}