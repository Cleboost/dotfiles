{
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.file.".local/bin" = {
    source = ../bin;
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
    desktop = null;
    publicShare = null;
    templates = null;
  };

  home.file.".hidden".text = "Games\n";

  programs.home-manager.enable = true;
}
