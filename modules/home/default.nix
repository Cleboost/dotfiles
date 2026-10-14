{ hostName, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    ../core/options.nix
    ../../hosts/${hostName}/profile.nix
    ../../hosts/${hostName}/home.nix
    ./session.nix
    ./shell
    ./desktop
    ./apps
  ];
}
