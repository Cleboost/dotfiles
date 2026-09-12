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

  # MangoHud configuration
  xdg.configFile."MangoHud/MangoHud.conf".source = ../files/mangohud/MangoHud.conf;

  # qBittorrent theme
  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source = ../files/qbittorrent/catppuccin-mocha.qbtheme;

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
    cursorTheme = {
      name = "cleboost-cursor";
      size = 18;
    };
  };

  # User applications and packages
  home.packages = with pkgs; [
    # ── Dev IA / IDE ───────────────────────────
    inputs.chatgpt-desktop.packages.${pkgs.system}.default
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-cli
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-ide

    # ── Daily Applications ──────────────────────────
    google-chrome
    discord
    nautilus
    inputs.fastpotify.packages.${pkgs.system}.default
    bitwarden-desktop
    qbittorrent
    evince
    feh
    mpv
    scrcpy
    android-tools
    prismlauncher
    blockbench

    # ── Developer Tools & Runtimes ──────────────────
    jdk21
    maven
    gradle
    bun
    nodejs_22
    rustup
    gcc
    gnumake

    # ── CLI & Terminal Utilities ────────────────────
    gh
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
    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify

    beammp-launcher
  ];
}
