{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    hm.imports = [ ./_base.nix ];
  };
}
