resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-terraform-remote-backend"
  location = "europe-central2"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"

  versioning {
    enabled = true
  }
 
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "$TF_VAR_BUCKET_NAME"
      prefix = "terraform/state"
    }
  }
  EOT
  # provisioner "local-exec" {
  #   command = "gsutil cp backend.tf gs://${google_storage_bucket.default.name}/backend.tf & / export TF_VAR_BUCKET_NAME=${google_storage_bucket.default.name}" 
  # }
  # depends_on = [google_storage_bucket.default]
}

module "cluster" {
  source = "./modules/cluster/"
  providers = {
    google = google
  }
}

module "apps" {
  source          = "./modules/apps/"
  default_cluster = module.cluster.default_cluster
  providers = {
    google = google
  }
}