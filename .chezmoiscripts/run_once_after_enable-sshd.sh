#!/bin/bash
# Enable and start SSH daemon

if systemctl list-unit-files | grep -q "^sshd\.service"; then
  if systemctl is-active --quiet sshd; then
    echo "SSH daemon is already active."
  else
    echo "=================================================="
    echo "Starting and enabling SSH daemon..."
    echo "=================================================="
    sudo systemctl enable --now sshd
  fi
fi
