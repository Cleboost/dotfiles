# ──────────────────────────────────────────────────────────────────────────────
# nixos/noctalia.nix — Noctalia shell, greeter (greetd), greeter user
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Noctalia shell ──────────────────────────────────────────────────────────
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # NetworkManager, Bluetooth, UPower, power-profiles
  };

  # ── Noctalia greeter (login screen) ─────────────────────────────────────────
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "cleboost" ];
    settings = {
      session.default = "hyprland";
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
