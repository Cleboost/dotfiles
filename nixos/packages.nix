# ──────────────────────────────────────────────────────────────────────────────
# nixos/packages.nix — fonts, fish, netbird, base system packages
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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

  # ── Shell & services ────────────────────────────────────────────────────────
  programs.fish.enable = true;
  services.netbird.enable = true;

  # ── Base CLI tools ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    nano
    pciutils
    usbutils
    evtest
  ];
}
