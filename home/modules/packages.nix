# All user packages: GUI apps, CLI tools, dev toolchains, and Wayland utilities
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # ── Applications Graphiques (GUI) ───────────────────────────
    # Navigateur & Communication
    google-chrome
    discord
    telegram-desktop

    # Multimédia, Documents & Partage
    nautilus
    lollypop
    mpv
    feh
    evince
    spotifast
    qbittorrent
    rquickshare

    # Productivité, Notes & Bureau à distance
    bitwarden-desktop
    obsidian
    scrcpy
    android-tools
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${pkgs.stdenv.hostPlatform.system}.rustdesk-flutter-nightly

    # Gaming & 3D
    prismlauncher
    blockbench
    beammp-launcher

    # ── Développement & IDEs ────────────────────────────────────
    # Éditeurs & Agents IA
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    antigravity-cli
    antigravity-ide
    inputs.chatgpt-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.grok-bot.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Compilateurs, Runtimes & Moteurs
    jdk21
    maven
    gradle
    bun
    nodejs_22
    rustup
    gcc
    gnumake
    godot_4

    # ── Utilitaires CLI & Système ───────────────────────────────
    gh
    nvd
    nixpkgs-review
    nix-output-monitor
    ripgrep
    fd
    jq
    fastfetch
    socat
    netcat-openbsd
    age
    p7zip
    unzip
    rsync

    # ── Wayland & Hyprland ──────────────────────────────────────
    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify
  ];
}
