terraform {
  required_version = "~> 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
provider "google" {
  project = "aqueous-sandbox-432016-j4"
  region  = "europe-central2"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}