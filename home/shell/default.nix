{ config, pkgs, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Direnv with nix-direnv integration (instant dev environments per project)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Zoxide (smart cd directory jumper with fzf support)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Yazi terminal file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

  # Eza (modern ls replacement)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };

  # Fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      clean-generations = "nh clean all --keep 10";
      please        = "sudo";
      cat           = "bat --paging=never";
      clear         = "printf '\\033[2J\\033[3J\\033[1;1H' && fastfetch-random";
      phonecam-start = "scrcpy --video-source=camera --camera-facing=back --camera-size=1920x1080 --camera-fps=30 --v4l2-sink=/dev/video20 --no-video-playback --v4l2-buffer=0";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
      fastfetch-random
    '';
  };

  # Bat (cat clone with syntax highlighting and git integration)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };

  # Fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "cleboost";
        email = "clement.balarot@gmail.com";
      };
      init.defaultBranch = "main";
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  # Starship config file symlink
  xdg.configFile."starship.toml".source = ./starship.toml;

  # Btop config
  xdg.configFile."btop/btop.conf".source = ./btop.conf;

  # Fastfetch config & images
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.dataFile."fastfetch/images".source = ./fastfetch/images;
}
