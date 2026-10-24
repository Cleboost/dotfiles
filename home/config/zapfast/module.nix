{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "social" config.cleboost.groups) {
  xdg.configFile."zapfast/settings.json" = {
    force = true;
    source = (pkgs.formats.json { }).generate "zapfast-settings.json" (import ./base.nix);
  };
}
