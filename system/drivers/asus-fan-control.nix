# ASUS EC fan control (Noctalia plugin on cleboost-sage).
{ config, lib, pkgs, ... }:

let
  cfg = config.drivers.asus-fan-control;
  asus-fan-control-ec = pkgs.callPackage ../pkgs/asus-fan-control-ec.nix { };
in
{
  options.drivers.asus-fan-control = {
    enable = lib.mkEnableOption "ASUS EC fan control";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ asus-fan-control-ec ];

    security.sudo.extraRules = [
      {
        users = [ "cleboost" ];
        commands = [
          {
            command = "${asus-fan-control-ec}/bin/asus-fan-control-ec";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
