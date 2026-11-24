{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm = {
      home.packages = [ pkgs.nautilus ];
      xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
      home.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
      xdg.dataFile."locale/fr/LC_MESSAGES/nautilus-open-any-terminal.mo".source =
        ./nautilus/nautilus-open-any-terminal.mo;
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
