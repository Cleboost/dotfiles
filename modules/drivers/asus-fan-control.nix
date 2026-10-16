# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-sage/asus-fan-control.nix — ASUS EC fan control (Noctalia plugin)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

let
  cfg = config.drivers.asus-fan-control;
in
{
  options.drivers.asus-fan-control = {
    enable = lib.mkEnableOption "ASUS EC fan control";
  };

  config = lib.mkIf cfg.enable {
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "asus-fan-control-ec";
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "Keyitdev";
        repo = "asus-fan-control-ec";
        rev = "master";
        sha256 = "0bmcnbpsj5zir3g2y6xb723bzv49bpp7hvgysivahfrxb3zi2ahg";
      };
      installPhase = ''
        mkdir -p $out/bin
        install -Dm755 asus-fan-control-ec $out/bin/asus-fan-control-ec
      '';
    })
  ];

  security.sudo.extraRules = [
    {
      users = [ "cleboost" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/asus-fan-control-ec";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
};
}
