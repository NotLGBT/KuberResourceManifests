terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 2.7.0"
    }
  }
}

# resource "google_service_account" "default" {
#   account_id = "1070081671072"
#   display_name = "Service Account"
  
# }

resource "google_compute_subnetwork" "custom" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-central2"
  network       = google_compute_network.custom.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

resource "google_compute_network" "custom" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_container_cluster" "primary" {
  name               = "my-vpc-native-cluster"
  location           = "europe-central2-a"
  remove_default_node_pool = true
  initial_node_count = 1

  network    = google_compute_network.custom.id
  subnetwork = google_compute_subnetwork.custom.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = google_compute_subnetwork.custom.secondary_ip_range.0.range_name
  }
  
}

resource "google_container_node_pool" "clusetr_node_pool" {
  name = "pool"
  cluster = google_container_cluster.primary.name
  node_count = 2
  location = "europe-central2-a"

  node_config {
    preemptible = true 
    machine_type = "e2-medium"

    service_account = "1070081671072-compute@developer.gserviceaccount.com"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  }

  
}