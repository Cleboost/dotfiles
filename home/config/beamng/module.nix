# Deploy Radial Cheat Menu (GE + vehicle) into BeamNG installs.
# Symlinks into the Steam game tree are invisible to the VFS when they point outside
# the install; we copy lua files instead. modScript stays a symlink in the user folder.
{ config, lib, ... }:

let
  cfg = config.cleboost.beamng.cheatMenu;
  menuSrc = ./beamng-radial-cheat-menu;
  menuRepo = "${config.home.homeDirectory}/dotfiles/home/config/beamng/beamng-radial-cheat-menu";
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
      srcModScript="$menuDir/modScript.lua"

      deploy_lua() {
        src="$1"
        dest="$2"
        mkdir -p "$(dirname "$dest")"
        if [ -L "$dest" ]; then
          $DRY_RUN_CMD rm -f "$dest"
        fi
        $DRY_RUN_CMD cp -f "$src" "$dest"
      }

      userBeamNG="${config.home.homeDirectory}/.local/share/BeamNG/BeamNG.drive/current"
      if [ -d "$userBeamNG" ]; then
        mkdir -p "$userBeamNG/scripts"
        $DRY_RUN_CMD ln -sfn "$srcModScript" "$userBeamNG/scripts/modScript.lua"
        deploy_lua "$srcGe" "$userBeamNG/lua/ge/extensions/cheatMenuu.lua"
        echo "beamng cheat menu: deployed GE lua + modScript → user folder"
      fi

      for root in ${lib.concatStringsSep " " (map (p: "\"${p}\"") cfg.installPaths)}; do
        if [ ! -d "$root/lua" ]; then
          echo "beamng cheat menu: skip (no lua): $root"
          continue
        fi
        deploy_lua "$srcGe" "$root/lua/ge/extensions/cheatMenuu.lua"
        deploy_lua "$srcVe" "$root/lua/vehicle/extensions/auto/codeCheatMenu.lua"
        if [ -d "$root/scripts" ] || mkdir -p "$root/scripts"; then
          deploy_lua "$srcModScript" "$root/scripts/modScript.lua"
        fi
        echo "beamng cheat menu: copied lua → $root"
      done
    '';
  };
}
