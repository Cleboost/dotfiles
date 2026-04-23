#!/usr/bin/env bash
# Trigger hotspot and suppress output to avoid system notification interference
/usr/bin/nmcli device wifi hotspot ifname wlan0 ssid cleboost-brain password "coucoubb" > /dev/null 2>&1

# Send only the Quickshell notification
/usr/bin/qs -c noctalia-shell ipc call toast send '{"title": "Hotspot", "body": "Hotspot cleboost-brain is now active", "icon": "network-wireless-hotspot"}'
