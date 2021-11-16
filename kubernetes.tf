provider "google" {
  project      = "syndeno"
  region       = var.region
  access_token = var.access_token
}

data "google_client_config" "provider" {}


data "google_container_cluster" "my_cluster" {
  name     = "syndeno"
  location = "europe-west4"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}


