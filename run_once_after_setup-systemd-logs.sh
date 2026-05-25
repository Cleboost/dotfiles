#!/bin/sh

if [ -f /etc/systemd/journald.conf ]; then
  if ! grep -q "^SystemMaxUse=100M" /etc/systemd/journald.conf; then
    echo "Configuring systemd journal logs limit to 100M..."
    sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/' /etc/systemd/journald.conf
    sudo sed -i 's/^SystemMaxUse=.*/SystemMaxUse=100M/' /etc/systemd/journald.conf
    sudo systemctl restart systemd-journald
    echo "Done! Logs limited to 100M."
  else
    echo "Systemd journal logs are already limited to 100M."
  fi
fi
