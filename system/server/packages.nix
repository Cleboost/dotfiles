{ pkgs, ... }:

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
}
