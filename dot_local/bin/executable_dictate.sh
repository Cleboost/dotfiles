#!/bin/bash

WAV_FILE="/tmp/dictation.wav"
MODEL="$HOME/.local/share/whisper-models/ggml-large-v3-turbo.bin"
WHISPER_BIN="/usr/bin/whisper-cli"

send_toast() {
    local title="$1"
    local body="$2"
    local icon="$3"
    local duration="${4:-5000}"
    qs -c noctalia-shell ipc call toast send "{\"title\": \"$title\", \"body\": \"$body\", \"icon\": \"$icon\", \"duration\": $duration}" > /dev/null 2>&1
}

dismiss_toast() {
    qs -c noctalia-shell ipc call toast dismiss > /dev/null 2>&1
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
