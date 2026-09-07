#!/bin/bash
# ecosystem-share.sh: Share clipboard URL/text or files with the other PC in the ecosystem

# Determine target host based on current hostname
HOSTNAME=$(hostname)
if [ "$HOSTNAME" = "cleboost-brain" ]; then
    TARGET_NAME="cleboost-sage"
elif [ "$HOSTNAME" = "cleboost-sage" ]; then
    TARGET_NAME="cleboost-brain"
else
    echo "Unknown host: $HOSTNAME" >&2
    exit 1
fi

# Find the KDE Connect device ID for the target host
# Get the list of devices and grep for our target hostname
DEVICE_ID=$(kdeconnect-cli -l | grep "$TARGET_NAME" | sed -E 's/.*: ([0-9a-fA-F]+) on.*/\1/')

# Fallback: simple grep/awk if regex parsing failed
if [ -z "$DEVICE_ID" ]; then
    DEVICE_ID=$(kdeconnect-cli -l | grep "$TARGET_NAME" | awk -F': ' '{print $2}' | awk '{print $1}')
fi

if [ -z "$DEVICE_ID" ]; then
    notify-send "Ecosystem Share" "Target device $TARGET_NAME not found or not connected." -u critical
    exit 1
fi

# If a file path is provided as argument, share the file (AirDrop)
if [ -n "$1" ]; then
    # Resolve absolute path
    ABS_PATH=$(realpath "$1")
    if [ -f "$ABS_PATH" ]; then
        kdeconnect-cli -d "$DEVICE_ID" --share "$ABS_PATH"
        notify-send "Ecosystem Share" "File '$(basename "$ABS_PATH")' sent to $TARGET_NAME"
    else
        notify-send "Ecosystem Share" "Error: File $1 does not exist." -u critical
    fi
else
    # Otherwise, check the clipboard for a URL or text to share (Handoff)
    if command -v wl-paste >/dev/null 2>&1; then
        CLIPBOARD_CONTENT=$(wl-paste -t text 2>/dev/null)
        if [ -n "$CLIPBOARD_CONTENT" ]; then
            # If it's a URL, open it on the other PC
            if [[ "$CLIPBOARD_CONTENT" =~ ^https?:// ]]; then
                kdeconnect-cli -d "$DEVICE_ID" --share "$CLIPBOARD_CONTENT"
                notify-send "Ecosystem Handoff" "Shared URL opened on $TARGET_NAME"
            else
                # Otherwise, send it as shared text
                kdeconnect-cli -d "$DEVICE_ID" --share-text "$CLIPBOARD_CONTENT"
                notify-send "Ecosystem Handoff" "Clipboard text sent to $TARGET_NAME"
            fi
        else
            notify-send "Ecosystem Handoff" "Clipboard is empty."
        fi
    else
        notify-send "Ecosystem Handoff" "Error: wl-clipboard not installed." -u critical
    fi
fi
