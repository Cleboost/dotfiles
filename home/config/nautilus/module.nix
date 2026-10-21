{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base-apps" config.cleboost.groups) {
  home.sessionVariables.NAUTILUS_4_EXTENSION_DIR =
    "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

  xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
    ./nautilus/nautilus-open-any-terminal.mo;
}
