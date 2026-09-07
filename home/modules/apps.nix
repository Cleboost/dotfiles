{ config, pkgs, ... }:

{
  # Zed editor configuration
  xdg.configFile."zed/settings.json".source = ../files/zed/settings.json;

  # Noctalia configuration
  xdg.configFile."noctalia/config.toml".source = ../files/noctalia/config.toml;

  # KDE Connect service
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # GTK Theme & Icons
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # User packages
  home.packages = with pkgs; [
    # Applications
    google-chrome
    discord
    spotify
    bitwarden-desktop
    qbittorrent
    feh
    mpv

    # Outils CLI & Développements
    eza
    ripgrep
    fd
    jq
    socat
    netcat-openbsd
    fzf
    age
    p7zip
    unzip
    rsync

    # Dev Runtimes
    bun
    nodejs_22
    rustup
    gcc
    gnumake

    # Wayland tools
    hyprpicker
    hyprshot
    wlsunset
    gpu-screen-recorder
    libnotify
  ];
}
