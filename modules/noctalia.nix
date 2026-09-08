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
}
