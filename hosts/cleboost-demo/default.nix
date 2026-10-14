# Portable demo: shared desktop with generic drivers, no host-specific overrides.
{ lib, ... }:

{
  # ── Feature & Application groups ────────────────────────────────────────────
  cleboost.groups = [
    "base-shell"
    "base-apps"
    "dev"
    "gui"
    "social"
    "media"
    "other"
    "gaming"
  ];

  networking.hostName = "cleboost-demo";

  # Do not import the laptop's NVIDIA PRIME/ASUS modules here.
  # The kernel supplies open Intel/AMD/Nouveau drivers where supported.
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  # A borrowed/demo PC should not start the private mesh VPN or Docker.
  services.netbird.enable = lib.mkForce false;
  virtualisation.docker.enable = lib.mkForce false;

  # On a persistent installation, require the local user's password for sudo.
  # The disposable live ISO overrides this for its ephemeral account.
  security.sudo.wheelNeedsPassword = lib.mkOverride 80 true;
}
