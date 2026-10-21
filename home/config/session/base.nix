{ config, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    download = "$HOME/Downloads";
    pictures = "$HOME/Pictures";
    music = "$HOME/Musics";
    videos = "$HOME/Videos";
    documents = "$HOME/Documents";
    projects = "${config.home.homeDirectory}/Projects";
    desktop = null;
    publicShare = null;
    templates = null;
    extraConfig = {
      # Pas dans le standard xdg-user-dirs, mais géré comme les autres (user-dirs.dirs + mkdir au switch)
      CODE = "${config.home.homeDirectory}/Code";
    };
  };

  home.file.".hidden".text = "Games\nLauncher.cfg\nLauncher.log\n";

  programs.home-manager.enable = true;
}
