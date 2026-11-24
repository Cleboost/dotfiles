{ inputs, ... }: {
  flake.modules.nixos.desktop = {
    imports = [ inputs.luciole.nixosModules.default ];
  };
}
