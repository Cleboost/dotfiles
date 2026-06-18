#!/bin/bash
# Enable and start the hypr-kdeconnect-portal user-level systemd service if installed

if systemctl --user list-unit-files | grep -q "^hypr-kdeconnect-portal\.service"; then
  if systemctl --user is-active --quiet hypr-kdeconnect-portal 2>/dev/null; then
    echo "hypr-kdeconnect-portal user service is already active."
  else
    echo "=================================================="
    echo "Starting and enabling hypr-kdeconnect-portal user service..."
    echo "=================================================="
    systemctl --user enable --now hypr-kdeconnect-portal.service
    systemctl --user restart xdg-desktop-portal.service
  fi
fi
