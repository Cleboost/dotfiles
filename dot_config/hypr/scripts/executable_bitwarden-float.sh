#!/bin/bash
# Listen to Hyprland socket2 for windowtitle events and float Bitwarden popups

SIG="${HYPRLAND_INSTANCE_SIGNATURE:-$(ls /run/user/${UID}/hypr/ | head -1)}"
SOCKET="/run/user/${UID}/hypr/${SIG}/.socket2.sock"

socat -U - "UNIX-CONNECT:${SOCKET}" | while read -r line; do
    event="${line%%>>*}"
    data="${line#*>>}"

    if [[ "$event" == "windowtitlev2" ]]; then
        addr="0x${data%%,*}"
        title="${data#*,}"

        if [[ "$title" == "Bitwarden" ]]; then
            hyprctl dispatch setfloating "address:${addr}"
            hyprctl dispatch resizewindowpixel "exact 400 600,address:${addr}"
            # Position: top-right with 50px top margin
            MONITOR_W=$(hyprctl monitors -j | jq '.[0].width')
            hyprctl dispatch movewindowpixel "exact $((MONITOR_W - 410)) 50,address:${addr}"
        fi
    fi
done
