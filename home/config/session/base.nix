{ config, lib, ... }:

{
  home = {
    sessionPath = [ "$HOME/.local/bin" ];

    file = {
      ".local/bin" = {
        source = ./scripts;
        recursive = true;
      };
      ".hidden".text = "Games\nLauncher.cfg\nLauncher.log\n";
      "Documents/Tools Torrent/toratio.js" = {
        source = ../../assets/toratio.js;
        executable = true;
      };
    };

    activation.toolsTorrentInput = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${config.home.homeDirectory}/Documents/Tools Torrent/input"
    '';
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
      # Not in the xdg-user-dirs standard, but managed like the others (user-dirs.dirs + mkdir on switch)
      CODE = "${config.home.homeDirectory}/Code";
    };
  };

  programs.home-manager.enable = true;
}
