{ config, lib, pkgs, ... }:

let
  projectsDir = "${config.home.homeDirectory}/Projects";
  iconFile = "${projectsDir}/.nautilus-folder-icon.svg";
in
{
  home.file."Projects/.nautilus-folder-icon.svg".source = ./projects-folder.svg;

  home.activation.projectsNautilusFolderIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    thumb_cache="${config.xdg.cacheHome}/thumbnails"
    if [ -d "${projectsDir}" ] && [ -e "${iconFile}" ]; then
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${projectsDir}" metadata::custom-icon-name
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t unset "${projectsDir}" metadata::custom-icon
      $DRY_RUN_CMD ${pkgs.glib}/bin/gio set -t string "${projectsDir}" metadata::custom-icon "file://${iconFile}"
      $DRY_RUN_CMD rm -rf "$thumb_cache"
      $DRY_RUN_CMD ${pkgs.util-linux}/bin/killall -q nautilus 2>/dev/null || true
    fi
  '';
}
