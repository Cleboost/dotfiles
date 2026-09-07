#!/bin/bash

WAV_FILE="/tmp/dictation.wav"
MODEL="$HOME/.local/share/whisper-models/ggml-large-v3-turbo.bin"
WHISPER_BIN="/usr/bin/whisper-cli"

NOTIF_ID_FILE="/tmp/dictation_notif_id"

send_toast() {
    local title="$1"
    local body="$2"
    local icon="$3"
    local duration="${4:-5000}"

    local id_arg=""
    [ -f "$NOTIF_ID_FILE" ] && id_arg="-r $(cat "$NOTIF_ID_FILE")"

    notify-send $id_arg -p -i "$icon" -t "$duration" "$title" "$body" > "$NOTIF_ID_FILE"
}

dismiss_toast() {
    if [ -f "$NOTIF_ID_FILE" ]; then
        notify-send -r "$(cat "$NOTIF_ID_FILE")" -t 1 "Dictée" "Terminé" > /dev/null 2>&1
        rm "$NOTIF_ID_FILE"
    fi
}

if pgrep -x "arecord" > /dev/null; then
    pkill -x "arecord"
    dismiss_toast
    send_toast "Dictée" "Transcription en cours" "loader-2"
    
    TEXT=$($WHISPER_BIN -l fr -nt -np -f "$WAV_FILE" -m "$MODEL" --prompt "Bonjour, je dicte du texte en français avec une articulation claire." 2>/dev/null)

    if [[ -n "$TEXT" ]]; then
        TEXT=$(echo -n "$TEXT" | tr -d '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        wtype -d 5 "$TEXT"
    else
        send_toast "Dictée" "Aucun texte détecté" "alert-circle"
    fi

    [ -f "$WAV_FILE" ] && rm "$WAV_FILE"
else
    send_toast "Dictée" "Enregistrement..." "microphone" 86400000
    arecord -r 16000 -f S16_LE -c 1 "$WAV_FILE" 2>/dev/null &
fi
