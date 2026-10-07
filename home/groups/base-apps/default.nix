{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base-apps" config.cleboost.groups) {
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

  home.sessionVariables.NAUTILUS_4_EXTENSION_DIR =
    "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

  xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
    ./nautilus/nautilus-open-any-terminal.mo;

  xdg.configFile."hypr/autostart/base-apps.lua".source = ./hypr-autostart.lua;

  xdg.mimeApps.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";
    "inode/directory" = "org.gnome.Nautilus.desktop";
  };
}
