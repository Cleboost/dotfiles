# VPS association — prod stable, Docker + Dokploy.
{ pkgs, lib, ... }:

let
  secretsDir = "/var/lib/secrets";
in
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # SeaBIOS legacy boot (GRUB on /dev/sda, no UEFI)
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi.canTouchEfiVariables = lib.mkForce false;
    grub = {
      enable = true;
      efiSupport = false;
    };
  };

  cleboost = {
    docker = true;
    openssh = true;
    server = true;
    ssh = true;
    terminal = {
      fastfetch = true;
      kitty = false;
      starship = true;
      zsh = true;
    };
  };

  networking.hostName = "vps-assosite";

  virtualisation.docker.daemon.settings.live-restore = false;

  system.activationScripts.dokploySecrets = lib.stringAfter [ "users" ] ''
    install -d -m 0700 -o root -g root ${secretsDir}
    for f in dokploy-db-password dokploy-auth-secret dokploy-encryption-key; do
      if [ ! -f "${secretsDir}/$f" ]; then
        if [ "$f" = "dokploy-encryption-key" ]; then
          ${pkgs.openssl}/bin/openssl rand -hex 32 > "${secretsDir}/$f"
        else
          ${pkgs.openssl}/bin/openssl rand -base64 32 > "${secretsDir}/$f"
        fi
        chmod 600 "${secretsDir}/$f"
      fi
    done
  '';

  services.dokploy = {
    enable = true;
    environment.TZ = "Europe/Paris";
    database.passwordFile = "${secretsDir}/dokploy-db-password";
    auth.secretFile = "${secretsDir}/dokploy-auth-secret";
    encryption.keyFile = "${secretsDir}/dokploy-encryption-key";
    swarm.advertiseAddress = "private";
  };
}
