{ ... }: {
  flake.modules.nixos.gaming = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      gamescope
      prismlauncher
      protontricks
    ];
  };
}
