output "redpanda_public_ip" {
  description = "Public IP of Redpanda VM"
  value       = google_compute_instance.redpanda.network_interface[0].access_config[0].nat_ip
}
