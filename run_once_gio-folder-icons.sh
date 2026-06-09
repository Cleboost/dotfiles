#!/bin/bash
# Set special folder icons via GIO metadata (runs once per machine)
gio set ~/Pictures metadata::custom-icon "file:///usr/share/icons/WhiteSur-dark/places/scalable/folder-pictures.svg"
gio set ~/Videos metadata::custom-icon "file:///usr/share/icons/WhiteSur-dark/places/scalable/folder-videos.svg"
gio set ~/Code metadata::custom-icon "file://${HOME}/.local/share/icons/custom/folder-code.svg"
gio set ~/Projects metadata::custom-icon "file://${HOME}/.local/share/icons/custom/folder-projects.svg"
