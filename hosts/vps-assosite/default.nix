# VPS association — prod stable, Docker + Dokploy.
{ pkgs, lib, ... }:

let
  secretsDir = "/var/lib/secrets";
in
{
  imports = [
    ../../system/server
    ../../home/hosts/vps-assosite/groups.nix
    ./hardware-configuration.nix
  ];

  cleboost.server = true;

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
