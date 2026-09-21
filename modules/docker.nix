# Docker containerization module
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Docker compose and container utilities
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
