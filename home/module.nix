# Home Manager — groups/ = paquets par groupe, config/ = configs app.
{ hostName, lib, ... }:

{
  imports = lib.optionals (builtins.pathExists (./hosts + "/${hostName}/home.nix")) [
    (./hosts + "/${hostName}/home.nix")
  ]
  ++ [
    ./config/module.nix
    ./groups/module.nix
  ];
}
