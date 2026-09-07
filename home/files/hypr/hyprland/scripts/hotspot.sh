#!/usr/bin/env bash
# Trigger hotspot and suppress output
/usr/bin/nmcli device wifi hotspot ifname wlan0 ssid cleboost-brain password "coucoubb" > /dev/null 2>&1

notify-send -a "Wifi" "Hotspot Activated" "Your Wi-Fi hotspot is now active." -i "network-wireless-hotspot-symbolic"
