{ ... }: {
  flake.modules.nixos.spotify = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      spotify
    ];
  };
}
