resource "null_resource" "sleep" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
}
resource "google_container_node_pool" "worker_nodes" {
  depends_on     = [null_resource.sleep]
  name           = var.node_pool_name
  location       = var.location
  project        = var.project_id
  version        = var.worker_nodes_version
  cluster        = "production-cluster"
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

