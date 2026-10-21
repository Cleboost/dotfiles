-- Deployed when cleboost.groups contains "base-apps"
hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 2 && nautilus --gapplication-service 2>/dev/null")
    hl.exec_cmd("jetbrain-fix")
    hl.exec_cmd("~/.config/hypr/scripts/bitwarden-float.sh")
    hl.exec_cmd("[workspace 1 silent] google-chrome-stable")
end)
