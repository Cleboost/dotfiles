# Home Manager — cleboost-sage only
{ pkgs, ... }:

{
  imports = [
    ./gpu-env.nix
  ];

  home.packages = with pkgs; [
  ];
}
