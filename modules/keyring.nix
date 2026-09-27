# Secret Service (org.freedesktop.secrets) for apps like ZapFast, Chrome, etc.
{ ... }:

{
  services.gnome.gnome-keyring.enable = true;

  # Unlock default keyring when logging in via Noctalia greeter (greetd)
  security.pam.services.greetd.enableGnomeKeyring = true;
}
