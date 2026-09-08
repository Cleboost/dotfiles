# Noctalia Shell & Noctalia Greeter (Login / Display Manager) Module
{ config, pkgs, ... }:

{
  # Noctalia Shell v5
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # NetworkManager, Bluetooth, UPower, power-profiles
  };

  # Noctalia Greeter (graphical login screen via Greetd)
  programs.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "cleboost" ];
    settings = {
      session.default = "hyprland";
      keyboard.layout = "fr";
    };
  };

  # Greetd session service
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  # Greeter system user
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };
  users.groups.greeter = {};

  # ASUS Fan Control EC package and passwordless sudo for noctalia plugin
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "asus-fan-control-ec";
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "Keyitdev";
        repo = "asus-fan-control-ec";
        rev = "master";
        sha256 = "1brfc7q09z0vvypqdzl9a9rwpm81pmwssh1djdiwx20l8nr6vxkd";
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
}
