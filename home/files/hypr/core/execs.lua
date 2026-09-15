-- Startup & Auto-execution
hl.on("hyprland.start", function()
    -- Shell & UI
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS")
    hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("systemctl --user start localsearch-3.service")
    hl.exec_cmd("sleep 2 && nautilus --gapplication-service 2>/dev/null")

    -- Input & Hardware
    hl.exec_cmd("hyprctl setcursor cleboost-cursor 18")
    hl.exec_cmd("steam -silent")
    hl.exec_cmd("jetbrain-fix")
    hl.exec_cmd("~/.config/hypr/scripts/manage_workspaces.sh")
    hl.exec_cmd("~/.config/hypr/scripts/bitwarden-float.sh")
    hl.exec_cmd("[workspace 1 silent] google-chrome-stable")

    -- Special apps (from specialwork)
    hl.exec_cmd("discord")
    hl.exec_cmd("fastpotify")
end)
