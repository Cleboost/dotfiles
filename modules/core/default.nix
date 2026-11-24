{ ... }: {
  flake.modules.nixos.core = { ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/cleboost/dotfiles";
    };
  };
}
