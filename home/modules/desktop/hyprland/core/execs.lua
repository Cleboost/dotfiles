hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS")
    hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("hyprctl dispatch 'hl.dsp.submap(\"global\")'")
    hl.exec_cmd("systemctl --user start localsearch-3.service")
    hl.exec_cmd("~/.config/hypr/scripts/manage_workspaces.sh")
end)

local ok, groups = pcall(require, "autostart._groups")
if ok and type(groups) == "table" then
    for _, group in ipairs(groups) do
        pcall(require, "autostart." .. group)
    end
end
