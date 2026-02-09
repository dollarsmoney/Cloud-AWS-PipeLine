resource "google_compute_instance" "redpanda" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {} # Public IP
  }

  metadata_startup_script = file("scripts/install_redpanda.sh")
}


resource "google_compute_firewall" "kafka" {
  name    = "allow-kafka-redpanda"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9092"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

# Firewall for observability (Node Exporter)
resource "google_compute_firewall" "observability" {
  name    = "allow-node-exporter"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9100"]  # Node Exporter default port
  }

  source_ranges = [var.monitor_ip]  # Only backend server can access
  direction     = "INGRESS"
}

