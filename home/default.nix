# ──────────────────────────────────────────────────────────────────────────────
# home/default.nix — shared Home Manager entry (all hosts)
# Host overrides: hosts/<hostname>/home.nix
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, hostName, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  # ── Module imports ────────────────────────────────────────────────────────
  imports = [
    ../modules/cleboost
    ../hosts/${hostName}/profile.nix
    ../hosts/${hostName}/home.nix
    ./packages
    ./shell
    ./kitty
    ./hyprland
    ./umbriel
    ./theme
    ./apps
    ./secrets.nix
  ];

  # ── Session ─────────────────────────────────────────────────────────────────
  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

  # ── XDG user directories ────────────────────────────────────────────────────
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

  home.file.".hidden".text = ''
    Games
  '';

  programs.home-manager.enable = true;
}
