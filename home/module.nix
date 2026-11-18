# Home Manager — groups/ = per-group packages, config/ = app configs.
{ hostName, lib, ... }:

{
  imports =
    lib.optionals (builtins.pathExists (./hosts + "/${hostName}/home.nix")) [
      (./hosts + "/${hostName}/home.nix")
    ]
    ++ [
      ./config/module.nix
      ./groups/module.nix
    ];
}
