# ──────────────────────────────────────────────────────────────────────────────
# home/apps/default.nix — default apps (MIME), desktop entries, app config files
# ──────────────────────────────────────────────────────────────────────────────
{ config, ... }:

{
  # ── Per-app config ──────────────────────────────────────────────────────────
  xdg.configFile."zed/settings.json".source = ./zed/settings.json;
  xdg.configFile."noctalia/config.toml".source = ./noctalia/config.toml;
  xdg.configFile."MangoHud/MangoHud.conf".source = ./mangohud/MangoHud.conf;
  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source = ./qbittorrent/catppuccin-mocha.qbtheme;

  # French locale for nautilus-open-any-terminal (.mo built from .po in this folder)
  xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
    ./nautilus/nautilus-open-any-terminal.mo;

  # ── Default applications (MIME) ─────────────────────────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web & internet
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/discord" = "discord.desktop";
      "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";

      # Documents & text
      "application/pdf" = "org.gnome.Evince.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
      "application/toml" = "dev.zed.Zed.desktop";

      # File manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Audio (Lollypop for library; mpv for video)
      "audio/mpeg" = "org.gnome.Lollypop.desktop";
      "audio/x-mpeg" = "org.gnome.Lollypop.desktop";
      "audio/mp3" = "org.gnome.Lollypop.desktop";
      "audio/x-mp3" = "org.gnome.Lollypop.desktop";
      "audio/ogg" = "org.gnome.Lollypop.desktop";
      "audio/flac" = "org.gnome.Lollypop.desktop";
      "audio/wav" = "org.gnome.Lollypop.desktop";
      "audio/x-vorbis+ogg" = "org.gnome.Lollypop.desktop";
      "audio/opus" = "org.gnome.Lollypop.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Images
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "image/webp" = "feh.desktop";
    };
  };

  # ── Custom desktop entries ──────────────────────────────────────────────────
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

  # ── WirePlumber (Bluetooth: disable HFP auto-switch) ────────────────────────
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
}
