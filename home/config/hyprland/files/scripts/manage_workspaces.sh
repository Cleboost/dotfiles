#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/hypr/workspaces.lua"

update_workspaces() {
    monitors_json=$(hyprctl monitors -j)
    if [[ -z "$monitors_json" ]]; then
        return
    fi

    internal=$(echo "$monitors_json" | jq -r '.[] | select(.name | startswith("eDP") or startswith("LVDS")) | .name' | head -n 1)
    # Sort external monitors by physical horizontal position (X coordinate)
    mapfile -t externals < <(echo "$monitors_json" | jq -r '[.[] | select(.name | startswith("eDP") or startswith("LVDS") | not)] | sort_by(.x) | .[].name')

    left_monitor=""
    center_monitor=""
    main_monitor=""
    secondary_monitor=""
    main_default_ws=1
    secondary_default_ws=11
    ext=""

    if (( ${#externals[@]} >= 2 )); then
        left_monitor="${externals[0]}"
        center_monitor="${externals[1]}"
        if [[ -z "$internal" ]]; then
            main_monitor="$left_monitor"
            secondary_monitor="$center_monitor"
        else
            main_monitor="$center_monitor"
            secondary_monitor="$left_monitor"
        fi
    elif (( ${#externals[@]} == 1 )); then
        ext="${externals[0]}"
    fi

    {
        echo "-- Generated dynamically by manage_workspaces.sh"
        
        if (( ${#externals[@]} >= 2 )); then
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = $w, monitor = \"$main_monitor\", default = $([[ $w -eq $main_default_ws ]] && echo "true" || echo "false") })"
            done
            for w in {11..20}; do
                echo "hl.workspace_rule({ workspace = $w, monitor = \"$secondary_monitor\", default = $([[ $w -eq $secondary_default_ws ]] && echo "true" || echo "false") })"
            done
            # Laptop monitor (right): Workspaces 21 to 30
            if [[ -n "$internal" ]]; then
                for w in {21..30}; do
                    echo "hl.workspace_rule({ workspace = $w, monitor = \"$internal\", default = $([[ $w -eq 21 ]] && echo "true" || echo "false") })"
                done
            fi
            
        elif (( ${#externals[@]} == 1 )); then
            for w in {1..10}; do
                echo "hl.workspace_rule({ workspace = $w, monitor = \"$ext\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
            if [[ -n "$internal" ]]; then
                for w in {11..20}; do
                    echo "hl.workspace_rule({ workspace = $w, monitor = \"$internal\", default = $([[ $w -eq 11 ]] && echo "true" || echo "false") })"
                done
                for w in {21..30}; do
                    echo "hl.workspace_rule({ workspace = $w, monitor = \"$ext\" })"
                done
            fi
        else
            target="${internal:-$(echo "$monitors_json" | jq -r '.[0].name')}"
            for w in {1..30}; do
                echo "hl.workspace_rule({ workspace = $w, monitor = \"$target\", default = $([[ $w -eq 1 ]] && echo "true" || echo "false") })"
            done
        fi
    } > "$CONFIG_PATH"

    hyprctl reload >/dev/null

    # Explicitly migrate any already-open workspaces to their assigned monitors
    if (( ${#externals[@]} >= 2 )); then
        for w in {1..10}; do
            hyprctl dispatch "hl.dsp.workspace.move({ workspace = $w, monitor = \"$main_monitor\" })" >/dev/null 2>&1
        done
        for w in {11..20}; do
            hyprctl dispatch "hl.dsp.workspace.move({ workspace = $w, monitor = \"$secondary_monitor\" })" >/dev/null 2>&1
        done
        if [[ -n "$internal" ]]; then
            for w in {21..30}; do
                hyprctl dispatch "hl.dsp.workspace.move({ workspace = $w, monitor = \"$internal\" })" >/dev/null 2>&1
            done
        fi
        current_active="$(hyprctl activeworkspace -j | jq -r '.id')"
        hyprctl dispatch "hl.dsp.focus({ monitor = \"$secondary_monitor\" })" >/dev/null 2>&1
        hyprctl dispatch "hl.dsp.focus({ workspace = $secondary_default_ws })" >/dev/null 2>&1
        if [[ -n "$internal" ]]; then
            hyprctl dispatch "hl.dsp.focus({ monitor = \"$internal\" })" >/dev/null 2>&1
            hyprctl dispatch "hl.dsp.focus({ workspace = 21 })" >/dev/null 2>&1
        fi
        hyprctl dispatch "hl.dsp.focus({ monitor = \"$main_monitor\" })" >/dev/null 2>&1
        hyprctl dispatch "hl.dsp.focus({ workspace = ${current_active:-1} })" >/dev/null 2>&1
    elif (( ${#externals[@]} == 1 )); then
        for w in {1..10}; do
            hyprctl dispatch "hl.dsp.workspace.move({ workspace = $w, monitor = \"$ext\" })" >/dev/null 2>&1
        done
        if [[ -n "$internal" ]]; then
            for w in {11..20}; do
                hyprctl dispatch "hl.dsp.workspace.move({ workspace = $w, monitor = \"$internal\" })" >/dev/null 2>&1
            done
            hyprctl dispatch "hl.dsp.focus({ monitor = \"$internal\" })" >/dev/null 2>&1
            hyprctl dispatch "hl.dsp.focus({ workspace = 11 })" >/dev/null 2>&1
            hyprctl dispatch "hl.dsp.focus({ monitor = \"$ext\" })" >/dev/null 2>&1
        fi
    fi

    if (( ${#externals[@]} >= 2 )) && [[ -z "$internal" ]]; then
        notify-send -a "Hyprland" -i "display" "Workspaces réorganisés" "Gauche (1-10) • Droite (11-20)" -t 3000
    else
        notify-send -a "Hyprland" -i "display" "Workspaces réorganisés" "Centre (1-10) • Gauche (11-20) • Portable (21-30)" -t 3000
    fi
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
