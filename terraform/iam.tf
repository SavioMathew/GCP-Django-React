resource "google_storage_bucket_iam_member" "application_raw_reader" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.application.email}"

  condition {
    title       = "ApplicationRawObjectReadAccess"
    description = "Allows application service account to read objects from the D0 Raw Landing bucket."
    expression = format(
      "resource.name.startsWith('projects/_/buckets/%s/objects/')",
      google_storage_bucket.d0_raw_landing.name
    )
  }
}

resource "google_storage_bucket_iam_member" "application_raw_writer" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.application.email}"

  condition {
    title       = "ApplicationRawObjectCreation"
    description = "Allows application service account to create objects in the D0 Raw Landing bucket."
    expression = format(
      "resource.name.startsWith('projects/_/buckets/%s/objects/')",
      google_storage_bucket.d0_raw_landing.name
    )
  }
}

resource "google_storage_bucket_iam_member" "data_engineering_raw_reader" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.data_engineering.email}"

  condition {
    title       = "DataEngineeringRawReadAccess"
    description = "Allows data engineering service account to read objects from the D0 Raw Landing bucket."
    expression = format(
      "resource.name.startsWith('projects/_/buckets/%s/objects/')",
      google_storage_bucket.d0_raw_landing.name
    )
  }
}

