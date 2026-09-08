{ config, pkgs, inputs, ... }:

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

  # Applications et paquets utilisateur
  home.packages = with pkgs; [
    # ── Écrans & Éditeurs ───────────────────────────
    zed-editor
    code-cursor
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-cli
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-ide

    # ── Applications Quotidiennes ───────────────────
    google-chrome
    discord
    spotify
    bitwarden-desktop
    qbittorrent
    feh
    mpv

    # ── Outils Développeur & Runtimes ──────────────
    bun
    nodejs_22
    rustup
    gcc
    gnumake

    # ── Utilitaires CLI & Terminal ──────────────────
    eza
    fastfetch
    btop
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

    # ── Utilitaires Wayland / Hyprland ───────────────
    hyprpicker
    hyprshot
    wlsunset
    gpu-screen-recorder
    libnotify
  ];
}
