# User packages installed on every host.
# Host-only apps go in hosts/<hostname>/home.nix.
{
  imports = [
    ./gui.nix
    ./dev.nix
    ./cli.nix
    ./wayland.nix
  ];
}
