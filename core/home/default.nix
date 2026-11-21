{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  myLib = import ../lib { inherit lib; };
  shellModules = [
    ../../modules/zsh/module.nix
    ../../modules/kitty/module.nix
    ../../modules/starship/module.nix
    ../../modules/fastfetch/module.nix
    ../../modules/ssh/module.nix
  ];
  allModules = myLib.scanModules ../../modules;
  desktopModules = lib.filter (m: !(lib.elem m shellModules)) allModules;
in
{
  imports =
    [ ./core.nix ]
    ++ shellModules
    ++ lib.optionals (!osConfig.cleboost.server) (
      [
        inputs.noctalia.homeModules.default
        inputs.umbriel.homeModules.default
      ]
      ++ desktopModules
    );
}
