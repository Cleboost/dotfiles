# Shared Noctalia config. Machine diffs: hosts/<hostname>/noctalia.nix (optional).
{ config, lib, pkgs, hostName, ... }:

let
  home = config.home.homeDirectory;
  base = import ./settings.nix { inherit home; };

  hostFile = ../../../../hosts/${hostName}/noctalia.nix;
  settings =
    if builtins.pathExists hostFile then
      import hostFile { inherit lib base home; }
    else
      base;

  toml = pkgs.formats.toml { };
in
{
  xdg.configFile."noctalia/config.toml".source =
    toml.generate "noctalia-config.toml" settings;
}
