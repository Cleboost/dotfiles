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
    functions = {
      rebuild = ''
        set -l old (readlink -f /run/current-system)
        sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain
        and nvd diff $old /run/current-system
      '';
      update = ''
        set -l old (readlink -f /run/current-system)
        nix flake update --flake /home/cleboost/dotfiles
        and sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain
        and nvd diff $old /run/current-system
      '';
    };
    shellAliases = {
      check-updates = "nix flake update --flake /home/cleboost/dotfiles && nixos-rebuild build --flake /home/cleboost/dotfiles#cleboost-brain && nvd diff /run/current-system ./result && rm -f ./result";
      check-diff    = "nvd diff (ls -dv /nix/var/nix/profiles/system-*-link | tail -n 2 | head -n 1) /run/current-system";
      please        = "sudo";
      ls            = "eza --icons --group-directories-first";
      ll            = "eza -alF --icons --group-directories-first";
      clear         = "printf '\\033[2J\\033[3J\\033[1;1H' && fastfetch-random";
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

  # Kitty extra files (search scripts)
  xdg.configFile."kitty/search.py".source = ../files/kitty/search.py;
  xdg.configFile."kitty/scroll_mark.py".source = ../files/kitty/scroll_mark.py;
}
