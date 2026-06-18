#!/bin/bash
# Ensure the current user is in the 'input' group to allow reading input events for plugins (like bongocat)

if ! groups | grep -q "\binput\b"; then
  echo "=================================================="
  echo "Adding user $USER to the 'input' group..."
  echo "Note: You will need to log out and log back in for this to take effect."
  echo "=================================================="
  sudo usermod -aG input "$USER"
fi
