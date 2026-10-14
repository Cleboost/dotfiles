# ──────────────────────────────────────────────────────────────────────────────
# home/shell/default.nix — Fish, Git, Starship, terminal tooling
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  imports = [
    ./secrets.nix
    ./starship.nix
  ];

  # ── Navigation & shell tooling ──────────────────────────────────────────────

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "noctalia";
      theme_background = true;
      truecolor = true;
      force_tty = false;
      vim_keys = false;
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };

  # ── Fish shell ──────────────────────────────────────────────────────────────
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

  # ── CLI helpers ─────────────────────────────────────────────────────────────
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # ── Git ─────────────────────────────────────────────────────────────────────
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

  # ── Static config files ─────────────────────────────────────────────────────
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.dataFile."fastfetch/images".source = ./fastfetch/images;
}
