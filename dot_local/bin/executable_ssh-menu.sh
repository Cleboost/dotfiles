#!/usr/bin/env bash
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.bitwarden-ssh-agent.sock}"

# Fetch SSH hosts from ~/.ssh/config (ignoring wildcards)
hosts=$(grep -i -E '^Host[[:space:]]+' ~/.ssh/config 2>/dev/null | sed -E 's/^Host[[:space:]]+//I' | tr -d '"' | grep -v '\*')

# If no hosts are found, prompt for manual input
if [ -z "$hosts" ]; then
    echo "No hosts found in ~/.ssh/config."
    read -p "Enter IP or hostname to connect to: " selected_host
else
    # Add option to manually input an IP/host
    selected_host=$( (echo "[Enter address manually]"; echo "$hosts") | fzf \
      --prompt="🖥️  Select SSH Host: " \
      --height=100% \
      --layout=reverse \
      --border=rounded \
      --margin=1 \
      --padding=1 \
      --color="bg+:-1,fg+:2,prompt:5,border:4" \
      --header="Press ESC to exit")
fi

# If manual entry is selected
if [ "$selected_host" = "[Enter address manually]" ]; then
    clear
    read -p "Enter connection address (e.g. user@ip): " manual_host
    if [ -n "$manual_host" ]; then
        selected_host="$manual_host"
    else
        exit 0
    fi
fi

# Connect if a host was selected
if [ -n "$selected_host" ] && [ "$selected_host" != "[Enter address manually]" ]; then
    # Disable floating mode if the window is currently floating
    if command -v hyprctl >/dev/null 2>&1 && hyprctl activewindow | grep -q "floating: 1"; then
        hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })'
    fi
    
    # Check if remote terminfo is needed for Kitty
    if [ "$TERM" = "xterm-kitty" ] && command -v kitty >/dev/null 2>&1; then
        echo "🔍 Checking remote terminal compatibility..."
        if ! ssh -o ConnectTimeout=3 -o BatchMode=yes "$selected_host" "infocmp xterm-kitty >/dev/null 2>&1"; then
            echo "📦 Copying Kitty terminfo to remote server..."
            kitty +kitten ssh "$selected_host" "exit" >/dev/null 2>&1
        fi
    fi

    clear
    echo "🔌 Connecting SSH to $selected_host..."
    ssh -t "$selected_host" "clear; exec \$SHELL"
    
    # Keep the terminal open briefly if the connection fails
    if [ $? -ne 0 ]; then
        echo -e "\n❌ Connection error. Closing in 5 seconds..."
        sleep 5
    fi
fi
