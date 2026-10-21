{ pkgs, ... }:

{
  imports = [
    ./secrets.nix
    ./phone-mic.nix
    (import ./base.nix { inherit pkgs; })
  ];
}
