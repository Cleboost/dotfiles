{ ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    hm.home.packages = [ pkgs.spotify ];
  };
}
