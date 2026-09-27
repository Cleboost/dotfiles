# User secret service (libsecret / org.freedesktop.secrets)
{ pkgs, ... }:

{
  services.gnome-keyring = {
    enable = true;
    # SSH stays on Bitwarden (see home/modules/shell.nix)
    enableSSHAgent = false;
  };

  home.packages = [ pkgs.libsecret ];
}
