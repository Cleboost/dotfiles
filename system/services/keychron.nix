# Keychron Launcher (WebHID) — accès hidraw pour Chrome/Chromium.
# Sans ça : le launcher voit le clavier mais la connexion reboucle.
{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="input", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
  '';
}
