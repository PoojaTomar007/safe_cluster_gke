variable "namespace" {
  description = "Name of the k8-proxy namespace"
  type        = string
  default     = "k8-proxy"
}

variable "gke_project_id" {
  description = "GCP project containing the gke cluster control plane"
  type        = string
}

variable "cluster_name" {
  description = "GCP gke cluster name"
  type        = string
}

variable "dns_domain" {
  description = "GCP dns domain"
  type        = string
}

variable "vpc_project_id" {
  description = "GCP project containing the shared vpc"
  type        = string
}

variable "gke_region" {
  type        = string
  description = "GKE region"
}

variable "helm_release_name" {
  type = string
}

variable "project_sa_credentials" {
  type      = string
  sensitive = true
}

variable "cwa_vpn_range" {
  type      = list(string)
  default   = ["0.0.0.0/0"]
}