#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/hypr/workspaces_rules.lua"

update_workspaces() {
    monitors_json=$(hyprctl monitors -j)
    if [[ -z "$monitors_json" ]]; then
        return
    fi

    internal=$(echo "$monitors_json" | jq -r '.[] | select(.name | startswith("eDP") or startswith("LVDS")) | .name' | head -n 1)
    mapfile -t externals < <(echo "$monitors_json" | jq -r '.[] | select(.name | startswith("eDP") or startswith("LVDS") | not) | .name' | sort)

    {
        echo "-- Generated dynamically by manage_workspaces.sh"
        
        if (( ${#externals[@]} >= 2 )); then
            ext1="${externals[0]}"
            ext2="${externals[1]}"
            
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$ext1\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
            if [[ -n "$internal" ]]; then
                for w in {11..20}; do
                    echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$internal\", default = $([[ $w -eq 11 ]] && echo "true" || echo "false") })"
                done
            fi
            for w in {21..30}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$ext2\", default = $([[ $w -eq 21 ]] && echo "true" || echo "false") })"
            done
            
        elif (( ${#externals[@]} == 1 )); then
            ext="${externals[0]}"
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$ext\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
            if [[ -n "$internal" ]]; then
                for w in {11..20}; do
                    echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$internal\", default = $([[ $w -eq 11 ]] && echo "true" || echo "false") })"
                done
                for w in {21..30}; do
                    echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$ext\", default = false })"
                done
            fi
        else
            target="${internal:-$(echo "$monitors_json" | jq -r '.[0].name')}"
            for w in {1..30}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$target\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
        fi
    } > "$CONFIG_PATH"

    hyprctl reload >/dev/null
}

if [[ "$1" == "--once" ]]; then
    update_workspaces
    exit 0
fi

# Run once at startup
update_workspaces

# Listen for monitor changes
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" && -n "$XDG_RUNTIME_DIR" ]]; then
    SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
    if [[ -S "$SOCKET_PATH" ]]; then
        nc -U "$SOCKET_PATH" | while read -r line; do
            if [[ "$line" == *"monitoradded>>"* || "$line" == *"monitorremoved>>"* ]]; then
                sleep 0.5
                update_workspaces
            fi
        done
    fi
fi
