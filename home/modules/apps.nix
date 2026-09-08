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

  # User applications and packages
  home.packages = with pkgs; [
    # ── Screens & Editors ───────────────────────────
    zed-editor
    code-cursor
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-cli
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-ide

    # ── Daily Applications ──────────────────────────
    firefox
    discord
    inputs.fastpotify.packages.${pkgs.system}.default
    bitwarden-desktop
    qbittorrent
    feh
    mpv

    # ── Developer Tools & Runtimes ──────────────────
    bun
    nodejs_22
    rustup
    gcc
    gnumake

    # ── CLI & Terminal Utilities ────────────────────
    eza
    fastfetch
    btop
    nvd
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

    # ── Wayland / Hyprland Utilities ────────────────
    hyprpicker
    wlsunset
    gpu-screen-recorder
    libnotify
  ];
}
