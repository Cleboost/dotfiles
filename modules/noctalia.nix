# Module Noctalia Shell & Noctalia Greeter (Écran de login / déverrouillage)
{ config, pkgs, ... }:

{
  # Noctalia Shell v5
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # NetworkManager, Bluetooth, UPower, power-profiles
  };

  # Noctalia Greeter (écran de connexion graphique avec Greetd)
  programs.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "cleboost" ];
    settings = {
      session.default = "hyprland";
      keyboard.layout = "fr";
    };
  };

  # Service de session greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  # Utilisateur système pour le greeter
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };
  users.groups.greeter = {};
}
