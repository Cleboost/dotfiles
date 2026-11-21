{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.baseApps {
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

  xdg = {
    configFile."hypr/autostart/base-apps.lua".source = ../hyprland/autostart/base-apps.lua;

    mimeApps.defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
