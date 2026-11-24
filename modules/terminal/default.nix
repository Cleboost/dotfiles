{ ... }: {
  flake.modules.nixos.terminal = { pkgs, ... }: {
    programs.fish.enable = true;

    hm = {
      home.packages = with pkgs; [
        fastfetch
      ];

      home.file.".local/bin/fastfetch-random" = {
        source = ./fastfetch/scripts/fastfetch-random;
        executable = true;
      };
      home.file.".local/bin/fastfetch-update-cache" = {
        source = ./fastfetch/scripts/fastfetch-update-cache;
        executable = true;
      };

      xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/assets/config.jsonc;
      xdg.dataFile."fastfetch/images".source = ./fastfetch/assets/images;

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        btop = {
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

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "y";
        };

        eza = {
          enable = true;
          enableFishIntegration = true;
          icons = "auto";
          git = true;
          extraOptions = [ "--group-directories-first" ];
        };

        fish = {
          enable = true;
          shellAliases = {
            clean-generations = "nh clean all --keep 10";
            please = "sudo";
            cat = "bat --paging=never";
            clear = "printf '\\033[2J\\033[3J\\033[1;1H' && fastfetch-random";
          };
          interactiveShellInit = ''
            set -g fish_greeting
            set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
            fastfetch-random
          '';
        };

        bat = {
          enable = true;
          config = {
            theme = "TwoDark";
            style = "numbers,changes,header";
          };
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
