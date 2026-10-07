{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "other" config.cleboost.groups) {
  home.packages = with pkgs; [ blockbench ];
}
