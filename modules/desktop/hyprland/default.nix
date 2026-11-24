{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    hm.imports = [ ./_module.nix ];
  };
}
