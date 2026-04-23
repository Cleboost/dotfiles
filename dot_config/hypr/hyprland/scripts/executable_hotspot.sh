#!/usr/bin/env bash
# Trigger hotspot
/usr/bin/nmcli device wifi hotspot ifname wlan0 ssid cleboost-brain password "coucoubb"

# Notification
/usr/bin/qs -c noctalia-shell ipc call toast send '{"title": "Hotspot", "body": "Hotspot cleboost-brain is now active", "icon": "network-wireless-hotspot"}' || \
/usr/bin/notify-send "Hotspot" "Hotspot cleboost-brain is now active" -i network-wireless-hotspot
