{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.nautilus {
  home.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

  xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
    ./nautilus/nautilus-open-any-terminal.mo;
}
