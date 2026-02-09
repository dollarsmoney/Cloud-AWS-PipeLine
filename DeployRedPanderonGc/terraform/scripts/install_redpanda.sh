#!/bin/bash
sudo apt update
sudo apt install -y curl

# Add Redpanda repo
curl -1sLf 'https://dl.redpanda.com/public/redpanda/setup.deb.sh' | sudo -E bash

# Install Redpanda
sudo apt install -y redpanda

# Start Redpanda
sudo systemctl start redpanda
sudo systemctl enable redpanda






# --- Install Node Exporter ---
NODE_VER="1.6.1"
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_VER/node_exporter-$NODE_VER.linux-amd64.tar.gz
tar xvf node_exporter-$NODE_VER.linux-amd64.tar.gz
sudo mv node_exporter-$NODE_VER.linux-amd64/node_exporter /usr/local/bin/

# Create systemd service for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Node Exporter
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
