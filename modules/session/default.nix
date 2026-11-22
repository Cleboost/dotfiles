{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    hm = { config, ... }: {
      home = {
        sessionPath = [ "$HOME/.local/bin" ];
        file.".hidden".text = "Games\nLauncher.cfg\nLauncher.log\n";
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
    };
  };
}
