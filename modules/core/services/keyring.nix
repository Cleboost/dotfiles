# ──────────────────────────────────────────────────────────────────────────────
# nixos/keyring.nix — GNOME Keyring (system) + greetd PAM unlock
# ──────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
