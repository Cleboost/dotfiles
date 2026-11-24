{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
