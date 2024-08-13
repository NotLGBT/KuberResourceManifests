
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