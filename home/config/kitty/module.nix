{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11.0;
    };

    settings = {
      cursor_shape = "beam";
      cursor_trail = 1;
      window_margin_width = "21.75";
      remember_os_window_size = false;
      initial_window_width = 900;
      initial_window_height = 520;
      confirm_os_window_close = 0;
      shell = "fish";
      background_opacity = "0.85";
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
    };

    extraConfig = ''
      include themes/noctalia.conf
    '';
  };

  xdg.configFile."kitty/search.py".source = ./search.py;
  xdg.configFile."kitty/scroll_mark.py".source = ./scroll_mark.py;
}
