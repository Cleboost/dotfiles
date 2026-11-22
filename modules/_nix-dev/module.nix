{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.nix-dev {
  home.packages = with pkgs; [
    nvd
    nixpkgs-review
    nix-output-monitor
    nix-update
  ];
}
