#!/bin/bash
# Enable and start SSH daemon for SFTP sharing

if systemctl list-unit-files | grep -q "^sshd\.service"; then
  if systemctl is-active --quiet sshd 2>/dev/null; then
    echo "SSH daemon is already active."
  else
    echo "=================================================="
    echo "Starting and enabling SSH daemon..."
    echo "=================================================="
    sudo systemctl enable --now sshd
  fi
fi
