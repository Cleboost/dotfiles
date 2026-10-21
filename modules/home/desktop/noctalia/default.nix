# Noctalia settings via official homeModules (flake noctalia).
# Host overlay: hosts/<hostname>/noctalia.nix. Binary + services: NixOS programs.noctalia.
{ config, lib, hostName, ... }:

let
  home = config.home.homeDirectory;
  base = import ./settings.nix { inherit home; };

  hostFile = ../../../../hosts/${hostName}/noctalia.nix;
  settings =
    if builtins.pathExists hostFile then
      import hostFile { inherit lib base home; }
    else
      base;
in
{
  programs.noctalia = {
    enable = true;
    # Installed system-wide; Hyprland starts noctalia (not systemd user service).
    package = lib.mkForce null;
    systemd.enable = false;
    checkConfig = false;
    settings = settings;
  };
}
