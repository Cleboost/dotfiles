# Declarative ZapFast settings (~/.config/zapfast/settings.json).
# accounts.json and ~/.local/state/zapfast/ stay user-managed.
{ config, lib, pkgs, ... }:

let
  json = pkgs.formats.json { };
  settings = import ./settings.nix;
in
lib.mkIf (lib.elem "social" config.cleboost.groups) {
  xdg.configFile."zapfast/settings.json".source =
    json.generate "zapfast-settings.json" settings;
}
