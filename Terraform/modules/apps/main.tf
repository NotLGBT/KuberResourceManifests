terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 2.7.0"
    }
    helm = {
      source = "hashicorp/helm"
      
    }
  }
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${var.default_cluster.endpoint  }"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(var.default_cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

resource "helm_release" "chart1" {
  name = "super-puper-release"
  repository = "https://notlgbt.github.io/KuberResourceManifests/"
  chart = "highreliable"
  set {
    name = "replicaCount"
    value = 2
  }
}