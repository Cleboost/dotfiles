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

  # Desktop entries
  xdg.desktopEntries = {
    cursor-acl = {
      name = "Cursor (ACL)";
      genericName = "Text Editor";
      comment = "Code Editing. Redefined. (ACL Environment)";
      exec = "cursor-acl %F";
      icon = "cursor";
      terminal = false;
      type = "Application";
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeType = [ "text/plain" "inode/directory" ];
      actions = {
        "new-empty-window" = {
          name = "New Empty Window";
          exec = "cursor-acl --new-window %F";
          icon = "cursor";
        };
      };
    };
  };

  # WirePlumber Bluetooth audio stability (disable HFP profile auto-switching)
  xdg.configFile."wireplumber/wireplumber.conf.d/10-bluetooth.conf".text = ''
    monitor.bluez.properties = {
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true
      bluez5.enable-hw-volume = true
      bluez5.auto-switch-profile = false
    }

    monitor.bluez.rules = [
      {
        matches = [
          {
            device.name = "~bluez_card.*"
          }
        ]
        actions = {
          update-props = {
            bluez5.auto-switch-profile = false
          }
        }
      }
    ]
  '';

  # MangoHud configuration
  xdg.configFile."MangoHud/MangoHud.conf".source = ../files/mangohud/MangoHud.conf;

  # qBittorrent theme
  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source = ../files/qbittorrent/catppuccin-mocha.qbtheme;

  # Nautilus open-any-terminal French translation ("Ouvrir dans le terminal")
  xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
    ../files/nautilus/nautilus-open-any-terminal.mo;

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
    inputs.chatgpt-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    zed-editor
    code-cursor
    (pkgs.writeShellScriptBin "cursor-acl" ''
      exec ${pkgs.code-cursor}/bin/cursor \
        --user-data-dir "$HOME/.config/cursor-acl" \
        --extensions-dir "$HOME/.cursor-acl/extensions" \
        "$@"
    '')
    (pkgs.writeShellScriptBin "cursor-pro" ''
      exec cursor-acl "$@"
    '')
    (pkgs.writeShellScriptBin "bluetooth-fix" ''
      echo "0000:06:00.4" | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind >/dev/null
      sleep 1
      echo "0000:06:00.4" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind >/dev/null
      sleep 2
      sudo systemctl restart bluetooth
      sleep 1
      bluetoothctl power on >/dev/null 2>&1
      sleep 1
      bluetoothctl connect 88:92:CC:9E:A3:56
    '')
    jetbrains.idea
    jetbrains.rust-rover
    antigravity-cli
    antigravity-ide

    # ── Daily Applications ──────────────────────────
    google-chrome
    discord
    telegram-desktop
    nautilus
    fastpotify
    bitwarden-desktop
    qbittorrent
    evince
    feh
    mpv
    scrcpy
    android-tools
    prismlauncher
    blockbench
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${pkgs.stdenv.hostPlatform.system}.rustdesk-flutter-nightly

    # ── CLI & Terminal Utilities ────────────────────
    gh
    eza
    fastfetch
    btop
    nvd
    nix-output-monitor
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
