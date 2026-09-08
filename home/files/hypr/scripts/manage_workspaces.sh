#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/hypr/workspaces.conf"

update_workspaces() {
    monitors_json=$(hyprctl monitors -j)
    if [[ -z "$monitors_json" ]]; then
        return
    fi

    internal=$(echo "$monitors_json" | jq -r '.[] | select(.name | startswith("eDP") or startswith("LVDS")) | .name' | head -n 1)
    # Sort external monitors by physical horizontal position (X coordinate)
    mapfile -t externals < <(echo "$monitors_json" | jq -r '[.[] | select(.name | startswith("eDP") or startswith("LVDS") | not)] | sort_by(.x) | .[].name')

    {
        echo "# Generated dynamically by manage_workspaces.sh"
        
        if (( ${#externals[@]} >= 2 )); then
            # externals[0] = Left monitor (x=0)
            # externals[1] = Central/Main monitor (x=1920)
            left_monitor="${externals[0]}"
            center_monitor="${externals[1]}"
            
            # Central monitor: Workspaces 1 to 10
            for w in {1..10}; do
                echo "workspace = $w, monitor:$center_monitor, default:$([[ $w -eq 1 ]] && echo "true" || echo "false")"
            done
            # Left monitor: Workspaces 11 to 20
            for w in {11..20}; do
                echo "workspace = $w, monitor:$left_monitor, default:$([[ $w -eq 11 ]] && echo "true" || echo "false")"
            done
            # Laptop monitor (right): Workspaces 21 to 30
            if [[ -n "$internal" ]]; then
                for w in {21..30}; do
                    echo "workspace = $w, monitor:$internal, default:$([[ $w -eq 21 ]] && echo "true" || echo "false")"
                done
            fi
            
        elif (( ${#externals[@]} == 1 )); then
            ext="${externals[0]}"
            for w in {1..10}; do
                echo "workspace = $w, monitor:$ext, default:$([[ $w -eq 1 ]] && echo "true" || echo "false")"
            done
            if [[ -n "$internal" ]]; then
                for w in {11..20}; do
                    echo "workspace = $w, monitor:$internal, default:$([[ $w -eq 11 ]] && echo "true" || echo "false")"
                done
                for w in {21..30}; do
                    echo "workspace = $w, monitor:$ext"
                done
            fi
        else
            target="${internal:-$(echo "$monitors_json" | jq -r '.[0].name')}"
            for w in {1..30}; do
                echo "workspace = $w, monitor:$target, default:$([[ $w -eq 1 ]] && echo "true" || echo "false")"
            done
        fi
    } > "$CONFIG_PATH"

    hyprctl reload >/dev/null
    notify-send -a "Hyprland" -i "display" "Workspaces réorganisés" "Centre (1-10) • Gauche (11-20) • Portable (21-30)" -t 3000
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
