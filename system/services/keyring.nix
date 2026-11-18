# ──────────────────────────────────────────────────────────────────────────────
# nixos/keyring.nix — GNOME Keyring (system) + greetd PAM unlock
# ──────────────────────────────────────────────────────────────────────────────
_:

{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
