# ──────────────────────────────────────────────────────────────────────────────
# home/secrets.nix — user Secret Service (libsecret); Bitwarden owns SSH
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "pkcs11" ];
  };

  home.packages = [ pkgs.libsecret ];
}
