# Symlink Radial Cheat Menu (GE + vehicle) into each BeamNG.drive install root.
{ config, lib, ... }:

let
  cfg = config.cleboost.beamng.cheatMenu;
  menuSrc = ./beamng-radial-cheat-menu;
  menuRepo = "${config.home.homeDirectory}/dotfiles/modules/home/apps/gaming/beamng-radial-cheat-menu";
in
{
  options.cleboost.beamng.cheatMenu = {
    enable = lib.mkEnableOption "Radial Cheat Menu → BeamNG lua (cheatMenuu + codeCheatMenu)";
    installPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "/mnt/games/SteamLibrary/steamapps/common/BeamNG.drive"
        "/home/cleboost/.local/share/Steam/steamapps/common/BeamNG.drive"
      ];
      description = "Absolute paths to BeamNG.drive folders (one per Steam library).";
    };
  };

  config = lib.mkIf (lib.elem "gaming" config.cleboost.groups && cfg.enable) {
    home.activation.beamngRadialCheatMenu = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu
      menuDir="${menuRepo}"
      if [ ! -f "$menuDir/cheatMenuu.lua" ]; then
        menuDir=${menuSrc}
      fi
      srcGe="$menuDir/cheatMenuu.lua"
      srcVe="$menuDir/codeCheatMenu.lua"
      for root in ${lib.concatStringsSep " " (map (p: "\"${p}\"") cfg.installPaths)}; do
        if [ ! -d "$root/lua" ]; then
          echo "beamng cheat menu: skip (no lua): $root"
          continue
        fi
        geDir="$root/lua/ge/extensions"
        veDir="$root/lua/vehicle/extensions/auto"
        mkdir -p "$geDir" "$veDir"
        ln -sfn "$srcGe" "$geDir/cheatMenuu.lua"
        ln -sfn "$srcVe" "$veDir/codeCheatMenu.lua"
        echo "beamng cheat menu: linked → $root"
      done
    '';
  };
}
