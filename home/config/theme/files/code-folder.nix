{ config, lib, pkgs, ... }:

let
  codeDir = "${config.home.homeDirectory}/Code";
  iconFile = "${codeDir}/.nautilus-folder-icon.svg";
in
{
  home.file."Code/.nautilus-folder-icon.svg".source = ./code-folder.svg;

  home.activation.codeNautilusFolderIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    thumb_cache="${config.xdg.cacheHome}/thumbnails"
    if [ -d "${codeDir}" ] && [ -e "${iconFile}" ]; then
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${codeDir}" metadata::custom-icon-name
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${codeDir}" metadata::custom-icon
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t string "${codeDir}" metadata::custom-icon "file://${iconFile}"
      $DRY_RUN_CMD rm -rf "$thumb_cache"
      $DRY_RUN_CMD ${pkgs.util-linux}/bin/killall -q nautilus 2>/dev/null || true
    fi
  '';
}
