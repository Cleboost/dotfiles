{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gui {
  home.packages = with pkgs; [
    obsidian
    scrcpy
    android-tools
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly
  ];
}
