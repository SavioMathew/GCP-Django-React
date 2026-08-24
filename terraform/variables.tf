variable "project_id" {
  description = "Google Cloud project ID."
  type        = string

  validation {
    condition     = length(var.project_id) > 5
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Google Cloud region."
  type        = string
  default     = "asia-south1"
}

variable "raw_bucket_name" {
  description = "Globally unique GCS bucket name for D0 Raw Landing."
  type        = string
}

variable "bigquery_dataset_id" {
  description = "BigQuery dataset ID for D1 Staged/Enforced."
  type        = string
  default     = "d1_staged_enforced"
}

variable "retention_days" {
  description = "Days before raw objects become eligible for deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_days >= 7
    error_message = "retention_days must be at least 7."
  }
}

