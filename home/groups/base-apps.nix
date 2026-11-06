{ config, lib, pkgs, ... }:

{
  imports = [
    ../config/nautilus/module.nix
  ];

  config = lib.mkIf (lib.elem "base-apps" config.cleboost.groups) {
    home.packages = with pkgs; [
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
      rquickshare
      bitwarden-desktop
      google-chrome
      nautilus
    ];

    xdg.configFile."hypr/autostart/base-apps.lua".source =
      ../config/hyprland/autostart/base-apps.lua;

    xdg.dataFile."dev.mandre.rquickshare/.settings.json" = {
      force = true;
      text = ''
        {
          "autostart": false,
          "visibility": 0,
          "startminimized": true,
          "realclose": false
        }
      '';
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
