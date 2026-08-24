resource "google_bigquery_dataset" "d1_staged_enforced" {
  project    = var.project_id
  dataset_id = var.bigquery_dataset_id
  location   = var.region

  description = "D1 Staged/Enforced dataset containing validated student onboarding data."

  delete_contents_on_destroy = false

  labels = {
    environment = "staging"
    project     = "gcp-django-react"
    managed_by  = "terraform"
    data_zone   = "d1"
  }

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_bigquery_table" "student_onboarding" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id   = "student_onboarding"

  deletion_protection = true

  schema = jsonencode([
    {
      name = "student_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "first_name"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "last_name"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "date_of_birth"
      type = "DATE"
      mode = "REQUIRED"
    },
    {
      name = "school_name"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "learning_difficulty"
      type = "BOOL"
      mode = "REQUIRED"
    },
    {
      name = "learning_difficulty_type"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "requires_lsa"
      type = "BOOL"
      mode = "REQUIRED"
    },
    {
      name = "parent_consent"
      type = "BOOL"
      mode = "REQUIRED"
    },
    {
      name = "parent_email"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "support_category"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "ingested_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "data_owner"
      type = "STRING"
      mode = "REQUIRED"
    }
  ])

  depends_on = [
    google_bigquery_dataset.d1_staged_enforced
  ]
}

