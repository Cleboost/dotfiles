#!/usr/bin/env bash
# Wi-Fi Hotspot toggle script for NetworkManager on NixOS

# Find active Wi-Fi interface (e.g. wlp3s0, wlan0)
WIFI_IFACE=$(nmcli -t -f DEVICE,TYPE device status | grep ':wifi$' | cut -d: -f1 | head -n 1)

if [ -z "$WIFI_IFACE" ]; then
    notify-send -a "Wifi" -u critical "Hotspot Error" "No Wi-Fi interface found." -i "network-wireless-offline-symbolic"
    exit 1
fi

HOTSPOT_CON_NAME="Hotspot"

# Check if Hotspot connection is currently active
ACTIVE_HOTSPOT=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ":wifi:${WIFI_IFACE}" | cut -d: -f1)

if [ -n "$ACTIVE_HOTSPOT" ] && [[ "$ACTIVE_HOTSPOT" =~ ^(Hotspot|cleboost-brain)$ ]]; then
    # Hotspot is active, turn it off
    nmcli connection down "$ACTIVE_HOTSPOT" >/dev/null 2>&1
    notify-send -a "Wifi" "Hotspot Disabled" "Wi-Fi hotspot has been stopped." -i "network-wireless-symbolic"
else
    # Start hotspot
    if nmcli connection show "Hotspot" >/dev/null 2>&1; then
        nmcli connection up "Hotspot" >/dev/null 2>&1
        STATUS=$?
    else
        nmcli device wifi hotspot ifname "$WIFI_IFACE" con-name "Hotspot" ssid "cleboost-brain" password "coucoubb" >/dev/null 2>&1
        STATUS=$?
    fi

    if [ $STATUS -eq 0 ]; then
        notify-send -a "Wifi" "Hotspot Activated" "SSID: cleboost-brain\nPassword: coucoubb" -i "network-wireless-hotspot-symbolic"
    else
        notify-send -a "Wifi" -u critical "Hotspot Failed" "Could not start hotspot on $WIFI_IFACE." -i "network-wireless-offline-symbolic"
    fi
fi
