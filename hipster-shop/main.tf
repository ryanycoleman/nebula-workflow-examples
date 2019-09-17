provider "google" {
  project     = "ryan-alliances"
  region      = "us-west1"
  zone        = "us-west1-b"
  credentials = "${var.credentials}"
}

terraform {
  required_version = ">= 0.12.6"
  backend "gcs" {
    bucket = "ryan-socks"
    prefix = "demo"
  }
}
resource "google_container_cluster" "k8sexample" {
  name               = "k8sexample-cluster"
  description        = "example k8s cluster"
  location           = "${local.workspace["gcp_location"]}"
  initial_node_count = 3
  enable_kubernetes_alpha = "true"
  enable_legacy_abac = "true" 
  # autoscaling {
  #   min_node_count = 0 
  #   max_node_count = 5
  # }
  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"
    client_certificate_config {
      issue_client_certificate = true
    }
  }
  node_config {
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}



# resource "google_container_cluster" "k8sexample" {
#   name     = "apparel-cluster"
#   location = "us-west1"
#   remove_default_node_pool = true
#   initial_node_count = 1
#   enable_kubernetes_alpha = "true"
#   enable_legacy_abac = "true" 
#   master_auth {
#     username = ""
#     password = ""

#     client_certificate_config {
#       issue_client_certificate = true
#     }
#   }
# }

# resource "google_container_node_pool" "k8sexample" {
#   name       = "apparel-nodes"
#   location   = "us-west1"
#   cluster    = "${google_container_cluster.k8sexample.name}"
#   initial_node_count = 1

#   autoscaling {
#     min_node_count = 0 
#     max_node_count = 4
#   }

#   node_config {
#     preemptible  = true
#     machine_type = "n1-standard-1"

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/compute",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#     ]
#   }
# }