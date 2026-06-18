#!/bin/bash
# Configure global GTK interface settings (themes, fonts, cursors, icons)

echo "=================================================="
echo "Configuring GTK Interface settings..."
echo "=================================================="

gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'cleboost-cursor'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'

# Configure fonts if available
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 12'
