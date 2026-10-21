# ──────────────────────────────────────────────────────────────────────────────
# home/theme/default.nix — GTK, Qt, icons, cursor, wallpapers
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

let
  cleboostIcons = import ./icon-theme.nix { inherit pkgs; };
in
{
  imports = [
    ./dotfiles-folder.nix
    ./code-folder.nix
    ./projects-folder.nix
  ];
  # ── Wallpapers & profile images ─────────────────────────────────────────────
  home.file."Pictures/Wallpapers".source = ../../../assets/wallpapers;
  home.file."Pictures/profile.png".source = ./profile.png;
  home.file."Pictures/banner.png".source = ./banner.png;

  home.packages = [ cleboostIcons pkgs.adwaita-icon-theme ];

  # ── GTK ─────────────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "cleboost-icons";
      package = cleboostIcons;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "cleboost-cursor";
      size = 18;
    };
    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Code Code"
      "file://${config.home.homeDirectory}/Downloads Downloads"
      "file://${config.home.homeDirectory}/Pictures Pictures"
      "file://${config.home.homeDirectory}/Musics Musics"
      "file://${config.home.homeDirectory}/Videos Videos"
    ];
  };

  # ── Qt & Kvantum ────────────────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum".source = ./qt/Kvantum;
  xdg.configFile."qt6ct".source = ./qt/qt6ct;

  # ── Cursor theme ────────────────────────────────────────────────────────────
  home.file.".local/share/icons/cleboost-cursor" = {
    source = ./cursor;
    recursive = true;
    force = true;
  };

  home.activation.removeLegacyIconOverlay = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD rm -rf "$HOME/.local/share/icons/WhiteSur-dark"
    $DRY_RUN_CMD rm -rf "$HOME/.local/share/icons/WhiteSur-dark-cleboost"
  '';

  home.activation.iconsLegacyCursor = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.icons"
    $DRY_RUN_CMD rm -rf "$HOME/.icons/cleboost-cursor"
    $DRY_RUN_CMD ln -sfn "$HOME/.local/share/icons/cleboost-cursor" "$HOME/.icons/cleboost-cursor"
  '';

  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=cleboost-cursor
  '';
}
