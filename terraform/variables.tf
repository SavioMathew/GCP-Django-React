# Google Cloud / Project Configuration

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

variable "zone" {
  description = "Google Cloud zone for the application VM."
  type        = string
  default     = "asia-south1-a"
}


# Google Cloud Storage

variable "raw_bucket_name" {
  description = "Globally unique GCS bucket name for D0 Raw Landing."
  type        = string
}


# BigQuery

variable "bigquery_dataset_id" {
  description = "BigQuery dataset ID for D1 Staged/Enforced."
  type        = string
  default     = "d1_staged_enforced"
}


# Data Retention

variable "retention_days" {
  description = "Days before raw objects become eligible for deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_days >= 7
    error_message = "retention_days must be at least 7."
  }
}


# Compute Engine VM

variable "vm_machine_type" {
  description = "Machine type for the application VM."
  type        = string
  default     = "e2-medium"
}

variable "vm_disk_size_gb" {
  description = "Boot disk size for the application VM in GB."
  type        = number
  default     = 30

  validation {
    condition     = var.vm_disk_size_gb >= 10
    error_message = "vm_disk_size_gb must be at least 10 GB."
  }
}


