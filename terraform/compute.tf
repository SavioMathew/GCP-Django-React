# =========================================================
# Compute Engine VM - Django + React POC
# =========================================================
#
# Security design:
#
#   Internet
#      |
#      |  No direct access to VM
#      |
#      X
#
#   Administrator
#      |
#      v
#   Google Cloud IAP
#      |
#      | TCP/22
#      v
#   Private Compute Engine VM
#
# The VM has NO external/public IP.
#
# Application architecture will later run inside Docker:
#
#   React  ---> Django  ---> MySQL
#
# MySQL will not be publicly exposed.
# =========================================================


# ---------------------------------------------------------
# Compute Engine VM
# ---------------------------------------------------------

resource "google_compute_instance" "application_vm" {
  name    = "django-react-application-vm"
  project = var.project_id
  zone    = var.zone

  # e2-medium = 2 vCPU + 4 GB RAM
  machine_type = "e2-medium"

  # -------------------------------------------------------
  # Network Tags
  # -------------------------------------------------------

  tags = [
    "django-react-app"
  ]

  # -------------------------------------------------------
  # Boot Disk
  # -------------------------------------------------------

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-balanced"
    }
  }

  # -------------------------------------------------------
  # Private Network Interface
  #
  # IMPORTANT:
  # No access_config block.
  #
  # Therefore the VM does NOT receive a public IP.
  # -------------------------------------------------------

  network_interface {
    network = "default"
  }

  # -------------------------------------------------------
  # Service Account
  # -------------------------------------------------------

  service_account {
    email = google_service_account.application.email

    scopes = [
      "cloud-platform"
    ]
  }

  # -------------------------------------------------------
  # OS Login
  # -------------------------------------------------------

  metadata = {
    enable-oslogin = "TRUE"
  }

  # -------------------------------------------------------
  # Dependencies
  # -------------------------------------------------------

  depends_on = [
    google_project_service.required_apis,
    google_service_account.application
  ]
}


# =========================================================
# Firewall Rules
# =========================================================


# ---------------------------------------------------------
# SSH - Google Cloud IAP
#
# IAP TCP forwarding source range:
# 35.235.240.0/20
#
# The VM is NOT publicly reachable on port 22.
# ---------------------------------------------------------

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "allow-ssh-iap-django-react"
  project = var.project_id
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"

    ports = [
      "22"
    ]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]

  target_tags = [
    "django-react-app"
  ]
}


# ---------------------------------------------------------
# HTTP - Port 80
#
# Currently disabled intentionally.
#
# The VM has no public IP, so direct public HTTP access
# is not possible.
#
# Later, if you deploy an external HTTPS Load Balancer,
# the load balancer can be allowed to reach the VM.
# ---------------------------------------------------------


# ---------------------------------------------------------
# HTTPS - Port 443
#
# Currently disabled intentionally.
#
# Later this can be opened only to the Google Cloud
# Load Balancer/backend infrastructure if required.
# ---------------------------------------------------------
