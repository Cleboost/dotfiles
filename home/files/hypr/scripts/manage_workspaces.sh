#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/hypr/workspaces_rules.lua"

update_workspaces() {
    monitors_json=$(hyprctl monitors -j)
    if [[ -z "$monitors_json" ]]; then
        return
    fi

    # Sort all active monitors from left to right (x position, then y)
    mapfile -t monitors < <(echo "$monitors_json" | jq -r 'sort_by(.x, .y)[] | .name')
    num_monitors=${#monitors[@]}

    if (( num_monitors == 0 )); then
        return
    fi

    {
        echo "-- Generated dynamically by manage_workspaces.sh"

        if (( num_monitors == 1 )); then
            mon="${monitors[0]}"
            for w in {1..30}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$mon\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
        elif (( num_monitors == 2 )); then
            mon1="${monitors[0]}"
            mon2="${monitors[1]}"
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$mon1\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
            for w in {11..20}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$mon2\", default = $([[ $w -eq 11 ]] && echo "true" || echo "false") })"
            done
            for w in {21..30}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$mon2\", default = false })"
            done
        elif (( num_monitors == 3 )); then
            left="${monitors[0]}"
            center="${monitors[1]}"
            right="${monitors[2]}"

            # Center (principal): 1..10
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$center\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
            # Left: 11..20
            for w in {11..20}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$left\", default = $([[ $w -eq 11 ]] && echo "true" || echo "false") })"
            done
            # Right: 21..30
            for w in {21..30}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$right\", default = $([[ $w -eq 21 ]] && echo "true" || echo "false") })"
            done
        else
            center_idx=$(( num_monitors / 2 ))
            center="${monitors[$center_idx]}"
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$center\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done

            block=1
            for i in "${!monitors[@]}"; do
                if (( i == center_idx )); then
                    continue
                fi
                mon="${monitors[$i]}"
                start_w=$(( block * 10 + 1 ))
                end_w=$(( (block + 1) * 10 ))
                for (( w = start_w; w <= end_w; w++ )); do
                    echo "hl.workspace_rule({ workspace = \"$w\", monitor = \"$mon\", default = $([[ $w -eq $start_w ]] && echo "true" || echo "false") })"
                done
                ((block++))
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
