{ config, pkgs, inputs, ... }:

let
  cleboostIcons = import ./lib/cleboost-icon-theme.nix { inherit pkgs; };
in
{
  # Zed editor configuration
  xdg.configFile."zed/settings.json".source = ../files/zed/settings.json;

  # Noctalia configuration
  xdg.configFile."noctalia/config.toml".source = ../files/noctalia/config.toml;

  # Qt & Kvantum theming
  xdg.configFile."Kvantum".source = ../files/qt/Kvantum;
  xdg.configFile."qt6ct".source = ../files/qt/qt6ct;

  # Default applications & MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web & Internet
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/discord" = "discord.desktop";
      "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";

      # Documents & Text
      "application/pdf" = "org.gnome.Evince.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
      "application/toml" = "dev.zed.Zed.desktop";

      # File Manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Audio (local library via Lollypop; mpv stays default for video)
      "audio/mpeg" = "org.gnome.Lollypop.desktop";
      "audio/x-mpeg" = "org.gnome.Lollypop.desktop";
      "audio/mp3" = "org.gnome.Lollypop.desktop";
      "audio/x-mp3" = "org.gnome.Lollypop.desktop";
      "audio/ogg" = "org.gnome.Lollypop.desktop";
      "audio/flac" = "org.gnome.Lollypop.desktop";
      "audio/wav" = "org.gnome.Lollypop.desktop";
      "audio/x-vorbis+ogg" = "org.gnome.Lollypop.desktop";
      "audio/opus" = "org.gnome.Lollypop.desktop";

      # Video & Media
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Images
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "image/webp" = "feh.desktop";
    };
  };

  # Desktop entries
  xdg.desktopEntries = {
    cursor-acl = {
      name = "Cursor (ACL)";
      genericName = "Text Editor";
      comment = "Code Editing. Redefined. (ACL Environment)";
      exec = "${config.home.homeDirectory}/.local/bin/cursor-acl %F";
      icon = "cursor";
      terminal = false;
      type = "Application";
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeType = [ "text/plain" "inode/directory" ];
      actions = {
        "new-empty-window" = {
          name = "New Empty Window";
          exec = "${config.home.homeDirectory}/.local/bin/cursor-acl --new-window %F";
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

  # GTK: Adwaita-dark + cleboost-icons (Adwaita UI, WhiteSur app icons in launchers only)
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "cleboost-icons";
      package = cleboostIcons;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "cleboost-cursor";
      size = 18;
    };
    gtk3.bookmarks = [
      "file:///home/cleboost/Code Code"
      "file:///home/cleboost/Downloads Downloads"
      "file:///home/cleboost/Pictures Pictures"
      "file:///home/cleboost/Musics Musics"
      "file:///home/cleboost/Videos Videos"
    ];
  };

  # XDG User Directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    download = "$HOME/Downloads";
    pictures = "$HOME/Pictures";
    music = "$HOME/Musics";
    videos = "$HOME/Videos";
    documents = "$HOME/Documents";
    desktop = null;
    publicShare = null;
    templates = null;
  };

  # Hide folders in file manager (Nautilus / GTK)
  home.file.".hidden".text = ''
    Games
  '';

}
