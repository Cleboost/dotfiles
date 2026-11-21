{
  lib,
  osConfig,
  pkgs,
  username,
  ...
}:

{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
    packages = lib.optionals osConfig.cleboost.desktop (
      with pkgs;
      [
        brightnessctl
        playerctl
        wl-clipboard
        hyprpicker
        wlsunset
        libnotify
      ]
    );
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
}
