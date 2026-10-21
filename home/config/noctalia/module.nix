{ config, lib, hostName, ... }:

let
  home = config.home.homeDirectory;
  hostLib = import ../../lib.nix { inherit lib hostName; };
  settings = hostLib.overlay (import ./base.nix { inherit home; }) ./hosts;
in
{
  programs.noctalia = {
    enable = true;
    package = lib.mkForce null;
    systemd.enable = false;
    checkConfig = false;
    settings = settings;
  };
}
