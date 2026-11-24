{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    hm.imports = [ ./_files ];
  };
}
