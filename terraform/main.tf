provider "google" {
  credentials = "account.json"
  project     = var.project_id
  region      = var.region
}

resource "google_storage_bucket" "state" {
     name     = var.state_bucket
     location = var.region
     project  = var.project_id
     storage_class = "STANDARD"
     force_destroy = true 
     versioning {
                 enabled = true
      }
}

resource "google_container_cluster" "primary" {
  name  = var.cluster_name
  location = var.region
  remove_default_node_pool = true
  initial_node_count = var.min_node_count
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name = "primary-nodes"
  location = var.region
  cluster = google_container_cluster.primary.name
  node_count = 1
  project = var.project_id

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible = var.preemptible
    machine_type = var.machine_type
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }
}

resource "google_artifact_registry_repository" "default" {
   project       = var.project_id
   location      = var.region
   repository_id = "cloud-run-artifact-regsitry"
   format        = "DOCKER"
   description   = "cloud-run repository"
 }

 resource "google_artifact_registry_repository_iam_binding" "default" {
  repository = google_artifact_registry_repository.default.name
  location   = var.region
  role       = "roles/artifactregistry.writer"
  project    = var.project_id

  members = [
    "user:brysonnyamwange@gmail.com"
  ]
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
  disable_on_destroy = true
}

resource "google_cloud_run_service" "default" {
name     = var.service_name
location = var.region
template {
    spec {
    containers {
        image = "nyamwange/infragcp:latest"
    }
    }
}
traffic {
    percent         = 100
    latest_revision = true
}
}

data "google_iam_policy" "noauth" {
binding {
    role = "roles/run.invoker"
    members = [
    "allUsers",
    ]
}
}

resource "google_cloud_run_service_iam_policy" "noauth" {
location    = google_cloud_run_service.default.location
project     = google_cloud_run_service.default.project
service     = google_cloud_run_service.default.name
policy_data = data.google_iam_policy.noauth.policy_data
}