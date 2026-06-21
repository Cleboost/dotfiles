#!/usr/bin/env bash

# Ensure the SSH agent is running and accessible
if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
    echo "❌ SSH Agent socket not found or not running. Make sure Bitwarden is open and SSH Agent is enabled."
    exit 1
fi

# Fetch public keys currently loaded in the agent
keys=$(ssh-add -L 2>/dev/null)

if [ -z "$keys" ] || [ "$keys" = "The agent has no identities." ]; then
    echo "⚠️ No identities found in SSH Agent. Please unlock your Bitwarden Vault first."
    exit 1
fi

mkdir -p "$HOME/.ssh"

# Loop through each public key line
echo "$keys" | while read -r key_line; do
    if [ -n "$key_line" ]; then
        # Extract the comment at the end of the line (e.g. "Cleboost (ED25519)" or "github")
        comment=$(echo "$key_line" | awk '{$1=$2=""; print $0}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        
        # Sanitize comment to make a clean filename (lowercase, alphanumeric/underscores)
        # e.g., "Cleboost (ED25519)" -> "cleboost"
        # e.g., "AUR (ED25519)" -> "aur"
        filename=$(echo "$comment" | awk '{print tolower($1)}' | sed 's/[^a-z0-9_.-]//g')
        
        if [ -n "$filename" ]; then
            pubkey_path="$HOME/.ssh/$filename.pub"
            echo "$key_line" > "$pubkey_path"
            chmod 600 "$pubkey_path"
            echo "✅ Synchronized: $pubkey_path ($comment)"
        fi
    fi
done
