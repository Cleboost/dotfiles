{ config, pkgs, ... }:

{
  # Zed editor configuration
  xdg.configFile."zed/settings.json".source = ../files/zed/settings.json;

  # Noctalia configuration
  xdg.configFile."noctalia/config.toml".source = ../files/noctalia/config.toml;

  # Qt & Kvantum theming
  xdg.configFile."Kvantum".source = ../files/qt/Kvantum;
  xdg.configFile."qt6ct".source = ../files/qt/qt6ct;

  # Spotify Wayland flags
  xdg.configFile."spotify-flags.conf".source = ../files/spotify-flags.conf;

  # Mime applications association
  xdg.configFile."mimeapps.list".source = ../files/mimeapps.list;


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
    # App
    google-chrome
    discord
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
