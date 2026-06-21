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

# Enable and start the KDE Connect clipboard sync service if installed
if systemctl --user list-unit-files | grep -q "^kdeconnect-clipboard-sync\.service"; then
  if systemctl --user is-active --quiet kdeconnect-clipboard-sync 2>/dev/null; then
    echo "kdeconnect-clipboard-sync user service is already active."
  else
    echo "=================================================="
    echo "Starting and enabling KDE Connect clipboard sync service..."
    echo "=================================================="
    systemctl --user enable --now kdeconnect-clipboard-sync.service
  fi
fi

# Enable and start the KDE Connect keepalive timer if installed
if systemctl --user list-unit-files | grep -q "^kdeconnect-keepalive\.timer"; then
  if systemctl --user is-active --quiet kdeconnect-keepalive.timer 2>/dev/null; then
    echo "kdeconnect-keepalive timer is already active."
  else
    echo "=================================================="
    echo "Starting and enabling KDE Connect keepalive timer..."
    echo "=================================================="
    systemctl --user enable --now kdeconnect-keepalive.timer
  fi
fi

