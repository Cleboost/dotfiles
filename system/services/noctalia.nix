# ──────────────────────────────────────────────────────────────────────────────
# nixos/noctalia.nix — Noctalia shell, greeter (greetd), greeter user
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, username, ... }:

{
  # ── Noctalia shell (package + services; settings → HM programs.noctalia.settings) ──
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # NetworkManager, Bluetooth, UPower, power-profiles
  };

  # ── Noctalia greeter (login screen) ─────────────────────────────────────────
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ username ];
    settings = {
      session.default = "umbriel";
      keyboard.layout = "fr";
    };
  };

  # ── Greetd ────────────────────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig.RestartSec = "1s";

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };
  users.groups.greeter = {};
}
