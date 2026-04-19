#!/bin/bash

SIZES=(16 20 22 24 28 32 40 48 56 64 72 80 88 96)
DEFAULT_SIZE=24
STATE_FILE="/tmp/hypr_cursor_size"
THEME="macOS"

# Load current size
if [ -f "$STATE_FILE" ]; then
    CURRENT_SIZE=$(cat "$STATE_FILE")
else
    CURRENT_SIZE=$DEFAULT_SIZE
fi

# Find current index
INDEX=-1
for i in "${!SIZES[@]}"; do
   if [[ "${SIZES[$i]}" == "${CURRENT_SIZE}" ]]; then
       INDEX=$i
       break
   fi
done

# Fallback if size not in list
if [ $INDEX -eq -1 ]; then
    INDEX=3 # Index of 24 in the array
fi

case "$1" in
    up)
        ((INDEX++))
        if [ $INDEX -ge ${#SIZES[@]} ]; then INDEX=$((${#SIZES[@]} - 1)); fi
        ;;
    down)
        ((INDEX--))
        if [ $INDEX -lt 0 ]; then INDEX=0; fi
        ;;
    reset)
        INDEX=3 # Index of 24
        ;;
    *)
        echo "Usage: $0 {up|down|reset}"
        exit 1
        ;;
esac

NEW_SIZE=${SIZES[$INDEX]}
echo "$NEW_SIZE" > "$STATE_FILE"

hyprctl setcursor "$THEME" "$NEW_SIZE"
notify-send "Cursor" "Size set to $NEW_SIZE" -t 1000 --icon=preferences-desktop-cursor
