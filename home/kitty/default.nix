# Kitty terminal
{ ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };

  # Search scripts
  xdg.configFile."kitty/search.py".source = ./search.py;
  xdg.configFile."kitty/scroll_mark.py".source = ./scroll_mark.py;
}
