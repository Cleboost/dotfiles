{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.rustdesk {
  home.packages = with pkgs; [
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly
  ];
}
