provider "google" {
  project = var.project_id
  region  = var.location
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.location
  project                  = var.project_id
  subnetwork               = var.subnetwork
  initial_node_count       = 1
  remove_default_node_pool = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name           = var.node_pool_name
  location       = var.location
  project        = var.project_id
  version        = var.worker_nodes_version
  cluster        = google_container_cluster.primary.name
  node_locations = var.node_locations
  node_count     = var.worker_nodes_count

  node_config {
    disk_size_gb = var.worker_nodes_disk_size
    machine_type = var.worker_node_type
    preemptible  = true
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    ]
  }
}
