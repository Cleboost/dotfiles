{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.fish.enable = true;
  services.netbird.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    htop
    nano
  ];

  fonts = lib.mkIf (!config.cleboost.server) {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      liberation_ttf
      corefonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Roboto"
          "Noto Sans"
          "DejaVu Sans"
        ];
        serif = [
          "Liberation Serif"
          "DejaVu Serif"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "DejaVu Sans Mono"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
