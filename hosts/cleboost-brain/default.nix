# Tower. Knobs for this machine live here. Shared system: modules/core, modules/drivers.
{ lib, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/drivers
    ./hardware-configuration.nix
    ./storage.nix
    ./ugreen-wifi.nix
  ];

  # ── Feature & Application groups ────────────────────────────────────────────
  cleboost.groups = [
    "base-shell"
    "base-apps"
    "dev"
    "ia"
    "gui"
    "social"
    "media"
    "other"
    "gaming"
  ];

  networking.hostName = "cleboost-brain";

  cleboost.hypr.dynamicWorkspaces = false;

  # Intel I211 — primary Ethernet when câble branché
  networking.firewall.trustedInterfaces = [ "enp5s0" ];

  # ── Hardware drivers ────────────────────────────────────────────────────────
  # Titan X Pascal → branche legacy 580 (driver 6xx refuse la carte)
  drivers.nvidia = {
    enable = true;
    packageFlavour = "legacy_580";
  };

  # ── Desktop performance (tower, pas de souci batterie) ──────────────────────
  boot.kernelParams = [
    "pcie_aspm.policy=performance"
  ];

  # Virtualisation / dev (5950X + 32 Go — KVM déjà dans hardware-configuration)
  boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
}
