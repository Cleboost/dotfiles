{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.cleboost.docker {
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
