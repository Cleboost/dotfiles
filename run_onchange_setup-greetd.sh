#!/bin/bash
# Noctalia greeter config — re-run if this file changes
# config-version: 1

set -e

sudo mkdir -p /etc/greetd
sudo tee /etc/greetd/config.toml > /dev/null << 'EOF'
[terminal]
vt = 1

[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
EOF

sudo systemctl enable greetd
sudo systemctl disable sddm 2>/dev/null || true

echo "greetd configured with noctalia-greeter"
