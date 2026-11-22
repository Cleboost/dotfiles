# modules/dev/default.nix
{ config, ... }:
let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.dev = {
    imports = [
      m.dev-ide
      m.dev-ia
      # m.dev-tools
    ];
  };
}
