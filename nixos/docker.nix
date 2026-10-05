# ──────────────────────────────────────────────────────────────────────────────
# nixos/docker.nix — Docker daemon and compose
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
