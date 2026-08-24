resource "google_service_account" "application" {
  project      = var.project_id
  account_id   = "application-sa"
  display_name = "Application Service Account"
  description  = "Least-privilege service account for application ingestion."
}

resource "google_service_account" "data_engineering" {
  project      = var.project_id
  account_id   = "data-engineering-sa"
  display_name = "Data Engineering Service Account"
  description  = "Controlled service account for data engineering operations."
}

