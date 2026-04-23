#!/usr/bin/env bash
nmcli device wifi hotspot ifname wlan0 ssid cleboost-brain password "coucoubb"
qs -c noctalia-shell ipc call toast send '{"title": "Hotspot", "body": "Hotspot cleboost-brain is now active", "icon": "network-wireless-hotspot"}' || \
notify-send "Hotspot" "Hotspot cleboost-brain is now active" -i network-wireless-hotspot
