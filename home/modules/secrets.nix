# User secret service (libsecret / org.freedesktop.secrets)
{ pkgs, ... }:

{
  services.gnome-keyring = {
    enable = true;
    # No "ssh" component — Bitwarden owns SSH (home/modules/shell.nix)
    components = [ "secrets" "pkcs11" ];
  };

  home.packages = [ pkgs.libsecret ];
}
