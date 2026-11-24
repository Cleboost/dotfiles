{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, username, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    users.users.${username}.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.docker-compose ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
