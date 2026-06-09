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
            # Get the monitor where Chrome is running
            CHROME_MONITOR=$(hyprctl clients -j | jq -r '.[] | select(.class == "google-chrome") | .monitor' | head -1)
            MONITOR_INFO=$(hyprctl monitors -j | jq ".[] | select(.id == ${CHROME_MONITOR})")
            MONITOR_X=$(echo "$MONITOR_INFO" | jq '.x')
            MONITOR_Y=$(echo "$MONITOR_INFO" | jq '.y')
            MONITOR_W=$(echo "$MONITOR_INFO" | jq '.width')
            POS_X=$(( MONITOR_X + MONITOR_W - 410 - 10 ))
            POS_Y=$(( MONITOR_Y + 150 ))
            hyprctl dispatch movewindowpixel "exact ${POS_X} ${POS_Y},address:${addr}"
        fi
    fi
done
