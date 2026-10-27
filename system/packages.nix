# ──────────────────────────────────────────────────────────────────────────────
# nixos/packages.nix — fonts, fish, netbird, base system packages
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.claude-desktop.overlays.default
  ];

  # ── Fonts ─────────────────────────────────────────────────────────────────────
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      liberation_ttf
      corefonts # Microsoft TrueType core fonts (Arial, Times New Roman, …)
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Roboto" "Noto Sans" "DejaVu Sans" ];
        serif = [ "Liberation Serif" "DejaVu Serif" ];
        monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # fish: NixOS enregistre le shell système ; HM (shell/base.nix) porte la config user.
  programs.fish.enable = true;
  services.netbird.enable = true;

  # Outils système (root / debug matériel) — apps user → home/groups/
  environment.systemPackages = with pkgs; [
    nano
    pciutils
    usbutils
    evtest
  ];
}
