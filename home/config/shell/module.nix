{ pkgs, ... }:

{
  imports = [
    ./secrets.nix
    (import ./base.nix { inherit pkgs; })
  ];
}
