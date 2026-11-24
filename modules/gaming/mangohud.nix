{ ... }: {
  flake.modules.nixos.gaming = { pkgs, ... }: {
    hm.home.packages = [ pkgs.mangohud ];
  };
}
