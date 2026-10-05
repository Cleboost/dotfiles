# Home Manager shared by every host. Host-only settings: hosts/<hostname>/home.nix
{ pkgs, hostName, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
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

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # User custom scripts into ~/.local/bin
  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
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

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
