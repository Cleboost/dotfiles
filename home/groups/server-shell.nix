{ lib, config, pkgs, ... }:

lib.mkIf (lib.elem "server-shell" config.cleboost.groups) {
  home.packages = with pkgs; [
    jq
    ripgrep
  ];
}
