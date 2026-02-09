variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-4"
}

variable "disk_size_gb" {
  type        = number
  default     = 100
}

variable "vm_name" {
  type        = string
  default     = "redpanda-1"
}

variable "monitor_ip" {
  type        = string
  description = "The backend server IP allowed to scrape metrics"
}
