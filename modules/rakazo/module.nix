{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.rakazo {
  home.packages = with pkgs; [
    (callPackage ../../pkgs/rakazo.nix { })
  ];
}
