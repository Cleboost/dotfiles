# Home Manager serveur — shell et rien d'autre.
{ hostName, lib, ... }:

{
  imports = [
    ./config/shell/module.nix
    ./config/fastfetch/module.nix
    ./config/starship/module.nix
    ./groups/module.nix
  ];

  xdg.mimeApps.enable = lib.mkForce false;
}
