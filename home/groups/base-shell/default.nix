{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base-shell" config.cleboost.groups) {
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify
  ];
}
