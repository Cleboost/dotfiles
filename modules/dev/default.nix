{ config, ... }:
let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.dev = {
    imports = [
      m.dev-ia
      m.dev-ide
      m.dev-rust
      m.dev-tool
    ];
  };
}
