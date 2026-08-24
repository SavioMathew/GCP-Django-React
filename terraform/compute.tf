# =========================================================
# Compute Engine VM - Django + React POC
# =========================================================

# ---------------------------------------------------------
# Static External IP
# ---------------------------------------------------------

resource "google_compute_address" "application_vm_ip" {
  name         = "application-vm-ip"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"

  depends_on = [
    google_project_service.required_apis
  ]
}


# ---------------------------------------------------------
# Compute Engine VM
# ---------------------------------------------------------

resource "google_compute_instance" "application_vm" {
  name    = "django-react-application-vm"
  project = var.project_id
  zone    = var.zone

  # e2-medium = 2 vCPU + 4 GB RAM
  machine_type = "e2-medium"

  tags = [
    "django-react-app",
    "http-server",
    "https-server"
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
  # Network Interface
  # -------------------------------------------------------

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.application_vm_ip.address
    }
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
# HTTP - Port 80
# ---------------------------------------------------------

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-django-react"
  project = var.project_id
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = [
      "80"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [
    "http-server"
  ]
}


# ---------------------------------------------------------
# HTTPS - Port 443
# ---------------------------------------------------------

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https-django-react"
  project = var.project_id
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = [
      "443"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [
    "https-server"
  ]
}


# ---------------------------------------------------------
# SSH - Google Cloud IAP
#
# IAP TCP forwarding uses:
# 35.235.240.0/20
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

