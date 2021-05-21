variable "cluster_name" {}

variable "location" {}

variable "project_id" {}

variable "master_version" {}

variable "subnetwork" {}


variable "node_pool_name" {}

variable "worker_nodes_version" {}

variable "node_locations" {
  type = list(any)
}

variable "worker_nodes_count" {}

variable "worker_nodes_disk_size" {}

variable "worker_node_type" {}


