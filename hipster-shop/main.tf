provider "google" {
  project     = "ryan-alliances"
  region      = "us-west1"
  zone        = "us-west1-b"
  credentials = file("/Users/ryan.coleman/.config/gcloud/application_default_credentials.json")
}

terraform {
  required_version = ">= 0.12.8"
  backend "gcs" {
    bucket = "ryan-socks"
    prefix = "demo"
  }
}

resource "google_container_cluster" "k8sexample" {
  name     = "apparel-cluster"
  location = "us-west1"
  remove_default_node_pool = true
  initial_node_count = 1
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "k8sexample" {
  name       = "apparel-nodes"
  location   = "us-west1"
  cluster    = "${google_container_cluster.k8sexample.name}"
  initial_node_count = 1

  autoscaling {
    min_node_count = 0 
    max_node_count = 4
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}