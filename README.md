# Cloud-AWS-PipeLine
Redpanda on Google Cloud Platform (GCP) with Terraform
Overview

This Terraform configuration provisions a production-ready Google Compute Engine (GCE) virtual machine running Ubuntu 22.04 and automatically installs Redpanda using a startup script.

It also configures firewall rules for:

Kafka / Redpanda Client Access on port 9092
Node Exporter / Observability Metrics on port 9100 (restricted to your monitoring server IP)

This setup is ideal for:

Kafka-compatible event streaming
Local DevOps labs
Distributed messaging systems
Monitoring and observability pipelines
Architecture
                    +----------------------+
                    | External Kafka Client |
                    |   (Public Internet)   |
                    +----------+-----------+
                               |
                               | TCP 9092
                               v
                    +----------------------+
                    |   GCP Redpanda VM    |
                    | Ubuntu 22.04         |
                    | Redpanda Broker      |
                    | Node Exporter        |
                    +----------+-----------+
                               |
                               | TCP 9100
                               v
                    +----------------------+
                    | Monitoring Backend    |
                    | (Prometheus/Grafana)  |
                    +----------------------+
Features
Compute Instance
Ubuntu 22.04 LTS
Configurable machine type
Configurable disk size
Public IP enabled
Startup script automation for Redpanda installation
Networking
Uses default VPC
Public Kafka access on 9092
Restricted Node Exporter metrics on 9100
Security
Observability firewall only allows a trusted monitoring IP
Kafka firewall open to all (can be restricted for production)
Terraform Resources
google_compute_instance.redpanda

Creates the VM instance.

Key Configuration:
machine_type = var.machine_type
zone         = var.zone
image        = ubuntu-2204-lts
google_compute_firewall.kafka

Allows Kafka traffic:

TCP 9092
source_ranges = ["0.0.0.0/0"]
google_compute_firewall.observability

Allows Node Exporter traffic:

TCP 9100
source_ranges = [var.monitor_ip]
Variables

Create a variables.tf file:

variable "vm_name" {
  description = "Name of the Redpanda VM"
  type        = string
}

variable "machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "monitor_ip" {
  description = "Trusted IP for Prometheus/Node Exporter"
  type        = string
}
Example terraform.tfvars
vm_name      = "redpanda-broker"
machine_type = "e2-standard-4"
zone         = "us-central1-a"
disk_size_gb = 100
monitor_ip   = "YOUR_MONITORING_SERVER_IP/32"
Startup Script Requirement

Your scripts/install_redpanda.sh should:

Install Redpanda
Configure broker settings
Enable and start service
Install Node Exporter
Expose metrics

Example:

#!/bin/bash
apt-get update -y
apt-get install -y curl

curl -1sLf \
  'https://packages.vectorized.io/public/redpanda/gpg.key' \
  | gpg --dearmor -o /usr/share/keyrings/redpanda-keyring.gpg

curl -1sLf \
  'https://packages.vectorized.io/public/redpanda/deb/ubuntu jammy main' \
  > /etc/apt/sources.list.d/redpanda.list

apt-get update -y
apt-get install -y redpanda

systemctl enable redpanda
systemctl start redpanda
Deployment Steps
1. Initialize Terraform
terraform init
2. Validate Configuration
terraform validate
3. Preview Deployment
terraform plan
4. Deploy Infrastructure
terraform apply -auto-approve
Verification
Check Redpanda:
ssh USER@VM_IP
sudo systemctl status redpanda
Kafka Port:
nc -zv VM_IP 9092
Node Exporter:
curl http://VM_IP:9100/metrics
Security Best Practices
Recommended Improvements:
Restrict Kafka firewall:
source_ranges = ["YOUR_OFFICE_IP/32"]
Use private VPC instead of public IP
Enable TLS for Redpanda
Configure SASL authentication
Use service accounts with least privilege
Add OS Login / SSH key hardening
Observability Stack Suggestion

Pair with:

Prometheus
Grafana
Alertmanager
Prometheus scrape config:
scrape_configs:
  - job_name: 'redpanda-node'
    static_configs:
      - targets: ['VM_IP:9100']
Common Commands
Destroy Infrastructure
terraform destroy
Show Outputs
terraform output
Troubleshooting
Startup Script Failed
sudo journalctl -u google-startup-scripts.service
Firewall Issues
gcloud compute firewall-rules list
Redpanda Logs
sudo journalctl -u redpanda
Production Considerations
Single Node = Good For:
Testing
Homelab
Learning Kafka
Development
Multi Node = Better For:
High availability
Partition replication
Fault tolerance
Real production workloads
Future Enhancements
Terraform modules
Managed instance groups
Internal load balancer
Multi-zone Redpanda cluster
Prometheus + Grafana automation
TLS + SASL security
Author Notes

This infrastructure gives you:

#Changes


Terraform + GCP + Redpanda + Observability

A strong foundation for:

Event streaming
Kafka labs
SRE practice
DevOps portfolio projects
