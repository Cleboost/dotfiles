#!/bin/bash
# Listen to Hyprland socket2 for windowtitle events and float Bitwarden popups

SOCKET="/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

socat -U - "UNIX-CONNECT:${SOCKET}" | while read -r line; do
    event="${line%%>>*}"
    data="${line#*>>}"

    if [[ "$event" == "windowtitle" ]]; then
        addr="0x${data}"
        title=$(hyprctl clients -j | jq -r ".[] | select(.address == \"${addr}\") | .title")
        class=$(hyprctl clients -j | jq -r ".[] | select(.address == \"${addr}\") | .class")

        if [[ "$class" == "google-chrome" && "$title" == *"Bitwarden"* ]]; then
            hyprctl dispatch setfloating "address:${addr}"
            hyprctl dispatch resizewindowpixel "exact 400 600,address:${addr}"
            hyprctl dispatch centerwindow "address:${addr}"
        fi
    fi
done
