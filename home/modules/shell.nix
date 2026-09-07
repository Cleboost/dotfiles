{ config, pkgs, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/cleboost/dotfiles-nixos#cleboost-brain";
      please  = "sudo";
      ls      = "eza --icons --group-directories-first";
      ll      = "eza -alF --icons --group-directories-first";
      clear   = "printf '\\033[2J\\033[3J\\033[1;1H' && fastfetch-random";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx PATH "$HOME/.local/bin" $PATH
      set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
      fastfetch-random
    '';
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../files/kitty/kitty.conf;
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
    };
  };

  # Starship config file symlink
  xdg.configFile."starship.toml".source = ../files/starship.toml;

  # Btop config
  xdg.configFile."btop/btop.conf".source = ../files/btop/btop.conf;

  # Fastfetch config & images
  xdg.configFile."fastfetch/config.jsonc".source = ../files/fastfetch/config.jsonc;
  xdg.dataFile."fastfetch/images".source = ../files/fastfetch/images;

  # Kitty extra files (search scripts, themes)
  xdg.configFile."kitty/search.py".source = ../files/kitty/search.py;
  xdg.configFile."kitty/scroll_mark.py".source = ../files/kitty/scroll_mark.py;
  xdg.configFile."kitty/themes".source = ../files/kitty/themes;
}
