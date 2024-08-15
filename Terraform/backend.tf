terraform {
  backend "gcs" {
    bucket = "none"
    prefix = "terraform/state"
  }
}
