{ inputs, ... }: {
  flake.modules.nixos.desktop = {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];
  };
}
