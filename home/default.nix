{ hostName, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    ../modules/cleboost
    ../hosts/${hostName}/profile.nix
    ../hosts/${hostName}/home.nix
    ./groups
    ./modules
  ];
}
