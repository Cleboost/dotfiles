{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "media" config.cleboost.groups) {
  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source =
    ./qbittorrent/catppuccin-mocha.qbtheme;

  home.activation.qbittorrentTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="${config.xdg.configHome}/qBittorrent/qBittorrent.conf"
    theme="${config.xdg.configHome}/qBittorrent/themes/catppuccin-mocha.qbtheme"
    $DRY_RUN_CMD mkdir -p "$(dirname "$conf")"
    $DRY_RUN_CMD ${pkgs.crudini}/bin/crudini --set "$conf" Preferences 'General\UseCustomUITheme' true
    $DRY_RUN_CMD ${pkgs.crudini}/bin/crudini --set "$conf" Preferences 'General\CustomUIThemePath' "$theme"
  '';
}
