resource "google_bigquery_row_access_policy" "student_data_owner_policy" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id   = google_bigquery_table.student_onboarding.table_id

  policy_id = "student-data-owner-access"

  filter_predicate = "data_owner = SESSION_USER()"

  grantees = [
    "serviceAccount:${google_service_account.application.email}"
  ]

  depends_on = [
    google_bigquery_table.student_onboarding,
    google_service_account.application
  ]
}

