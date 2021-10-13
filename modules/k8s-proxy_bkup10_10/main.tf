terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

data "google_container_cluster" "cluster" {
  project  = var.gke_project_id
  name     = var.cluster_name
  location = var.gke_region
}

resource "kubernetes_namespace" "k8-proxy" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "k8-proxy" {
  chart      = "${path.module}/helm/"
  name       = var.helm_release_name
  namespace  = var.namespace
  version    = 0.1

  values = [
    file("${path.module}/helm/values.yaml")
  ]
  
  set {
    name = "service.dnsName"
    value = "k8s-proxy.primary.k8.${var.dns_domain}"
  }

  depends_on = [
    kubernetes_namespace.k8-proxy
  ]

}

resource "google_compute_firewall" "k8_proxy_firewall" {
  project     = var.vpc_project_id
  name        = "${data.google_container_cluster.cluster.name}-k8-proxy"
  description = "Allows users to access proxy"
  network     = data.google_container_cluster.cluster.network

  allow {
    protocol = "tcp"
    ports    = ["8118"]
  }

  target_tags   = ["gke-${data.google_container_cluster.cluster.name}"]
  source_ranges = var.range
}