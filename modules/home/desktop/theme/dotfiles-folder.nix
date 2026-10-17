{ config, lib, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  iconFile = "${dotfilesDir}/.nautilus-folder-icon.svg";
in
{
  home.file."dotfiles/.nautilus-folder-icon.svg".source = ./dotfiles-folder.svg;

  home.activation.dotfilesNautilusFolderIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    legacy_icon="${config.home.homeDirectory}/.local/share/icons/dotfiles-folder.svg"
    thumb_cache="${config.xdg.cacheHome}/thumbnails"
    if [ -d "${dotfilesDir}" ] && [ -e "${iconFile}" ]; then
      $DRY_RUN_CMD rm -f "$legacy_icon"
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${dotfilesDir}" metadata::custom-icon-name
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${dotfilesDir}" metadata::custom-icon
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t string "${dotfilesDir}" metadata::custom-icon "file://${iconFile}"
      $DRY_RUN_CMD rm -rf "$thumb_cache"
      $DRY_RUN_CMD ${pkgs.util-linux}/bin/killall -q nautilus 2>/dev/null || true
    fi
  '';
}
