{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "gui" config.cleboost.groups) {
  home.packages = with pkgs; [
    obsidian
    scrcpy
    android-tools
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly
  ];
}
