#!/bin/bash
# Enable and start the NetBird systemd service if installed

if command -v netbird >/dev/null 2>&1; then
  if systemctl is-active --quiet netbird 2>/dev/null; then
    echo "NetBird service is already active."
  else
    echo "=================================================="
    echo "Starting and enabling NetBird systemd service..."
    echo "=================================================="
    sudo systemctl enable --now netbird
  fi
fi
