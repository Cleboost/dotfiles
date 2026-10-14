{ lib, ... }:

{
  imports = [
    ./nvidia.nix
    ./asus-fan-control.nix
  ];
}
