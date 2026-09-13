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

  # Fish shell
  programs.fish = {
    enable = true;
    functions = {
      rebuild = ''
        set -l old (readlink -f /run/current-system)
        sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain
        and nvd diff $old /run/current-system
        and fastfetch-update-cache
      '';
      update = ''
        set -l old (readlink -f /run/current-system)
        nix flake update --flake /home/cleboost/dotfiles
        and sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain
        and nvd diff $old /run/current-system
        and fastfetch-update-cache
      '';
    };
    shellAliases = {
      clean-generations = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage";
      please        = "sudo";
      ls            = "eza --icons --group-directories-first";
      ll            = "eza -alF --icons --group-directories-first";
      clear         = "printf '\\033[2J\\033[3J\\033[1;1H' && fastfetch-random";
      phonecam-start = "scrcpy --video-source=camera --camera-facing=back --camera-size=1920x1080 --camera-fps=30 --v4l2-sink=/dev/video20 --no-video-playback --v4l2-buffer=0";
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
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
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
