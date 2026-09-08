# System packages and software module
{ config, pkgs, inputs, ... }:

{
  # Allow proprietary packages (e.g. nvidia drivers, cursor, discord, etc.)
  nixpkgs.config.allowUnfree = true;

  # System fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      liberation_ttf
      corefonts # Microsoft TrueType core fonts (Arial, Times New Roman, etc.)
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

  # Enable Fish shell system-wide for completions and vendor functions
  programs.fish.enable = true;

  # Netbird & Services
  services.netbird.enable = true;

  # Base administrative tools and system utilities
  environment.systemPackages = with pkgs; [
    git
    nano
    pciutils
    usbutils
    brightnessctl
    playerctl
    wl-clipboard
    gh
  ];
}
