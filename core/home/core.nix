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
    )
    ++ lib.optionals (
      osConfig.cleboost.terminal.zsh
      || osConfig.cleboost.terminal.kitty
      || osConfig.cleboost.terminal.starship
      || osConfig.cleboost.terminal.fastfetch
    ) (with pkgs; [
      ripgrep
      fd
      jq
    ])
    ++ lib.optionals (
      osConfig.cleboost.file-manager.nautilus || osConfig.cleboost.file-manager.luciole
    ) (with pkgs; [
      age
      p7zip
      unzip
      rsync
    ]);
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
}
