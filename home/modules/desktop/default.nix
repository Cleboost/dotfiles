{
  imports = [
    ./hyprland
    ./hypr-autostart.nix
    ./kitty
    ./theme
  ];

  xdg.configFile."noctalia/config.toml".source = ./noctalia/config.toml;

  xdg.configFile."wireplumber/wireplumber.conf.d/10-bluetooth.conf".text = ''
    monitor.bluez.properties = {
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true
      bluez5.enable-hw-volume = true
      bluez5.auto-switch-profile = false
    }

    monitor.bluez.rules = [
      {
        matches = [ { device.name = "~bluez_card.*" } ]
        actions = {
          update-props = { bluez5.auto-switch-profile = false }
        }
      }
    ]
  '';
}
