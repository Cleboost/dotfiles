#!/bin/bash
# Enable and start the NetBird systemd service if installed

if command -v netbird >/dev/null 2>&1; then
  # Reload daemon to make sure newly installed services are recognized
  sudo systemctl daemon-reload

  if systemctl is-active --quiet netbird 2>/dev/null || systemctl is-active --quiet netbird@root 2>/dev/null; then
    echo "NetBird service is already active."
  else
    echo "=================================================="
    echo "Starting and enabling NetBird systemd service..."
    echo "=================================================="
    if systemctl list-unit-files | grep -q "^netbird\.service"; then
      sudo systemctl enable --now netbird
    elif systemctl list-unit-files | grep -q "^netbird@\.service"; then
      sudo systemctl enable --now netbird@root
    else
      echo "Warning: NetBird systemd service unit not found."
    fi
  fi
fi
