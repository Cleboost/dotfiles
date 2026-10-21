{ config, lib, pkgs, hostName, ... }:

let
  manageWorkspacesLine = lib.optionalString config.cleboost.hypr.dynamicWorkspaces ''
    hl.exec_cmd("bash -c '$HOME/.config/hypr/scripts/manage_workspaces.sh'")
  '';

  execsLua = ''
    hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS")
        hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
        hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service")
        hl.exec_cmd("noctalia")
        hl.exec_cmd("hyprctl dispatch 'hl.dsp.submap(\"global\")'")
        hl.exec_cmd("systemctl --user start localsearch-3.service")
    ${manageWorkspacesLine}
    end)

    local ok, groups = pcall(require, "autostart._groups")
    if ok and type(groups) == "table" then
        for _, group in ipairs(groups) do
            pcall(require, "autostart." .. group)
        end
    end
  '';

  hyprCore = pkgs.runCommand "hypr-core" {
    execs = pkgs.writeText "execs.lua" execsLua;
  } ''
    mkdir -p "$out"
    cp -r ${./files/core}/. "$out/"
    cp "$execs" "$out/execs.lua"
  '';
in
{
  imports = lib.optionals (builtins.pathExists (./hosts + "/${hostName}.nix")) [
    (./hosts + "/${hostName}.nix")
  ];

  xdg.configFile."hypr/hyprland.lua" = {
    source = ./files/hyprland.lua;
    force = true;
  };
  xdg.configFile."hypr/custom.lua".source = ./files/custom.lua;
  xdg.configFile."hypr/core".source = hyprCore;
  xdg.configFile."hypr/binds".source = ./files/binds;
  xdg.configFile."hypr/rules".source = ./files/rules;
  xdg.configFile."hypr/theme".source = ./files/theme;
  xdg.configFile."hypr/scripts".source = ./files/scripts;
  xdg.configFile."hypr/move-special.sh".source = ./files/move-special.sh;
}
