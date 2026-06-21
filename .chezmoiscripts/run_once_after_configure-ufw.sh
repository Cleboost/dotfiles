#!/bin/bash
# Configure UFW firewall for KDE Connect if installed

if command -v ufw >/dev/null 2>&1; then
  echo "=================================================="
  echo "Configuring UFW rules for KDE Connect..."
  echo "=================================================="
  sudo ufw allow 1714:1764/udp
  sudo ufw allow 1714:1764/tcp
  sudo ufw reload
fi
