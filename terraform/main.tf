locals {
  common_labels = {
    environment = "staging"
    project     = "gcp-django-react"
    managed_by  = "terraform"
    data_zone   = "d0"
  }
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "storage.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

resource "google_storage_bucket" "d0_raw_landing" {
  name     = var.raw_bucket_name
  project  = var.project_id
  location = var.region

  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.retention_days
    }

    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }

    action {
      type = "Delete"
    }
  }

  labels = local.common_labels

  depends_on = [
    google_project_service.required_apis
  ]
}
