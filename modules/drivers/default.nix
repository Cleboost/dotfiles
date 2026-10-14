{ lib, ... }:

{
  imports = [
    ./nvidia.nix
    ./amdgpu.nix
    ./intel.nix
    ./vm.nix
    ./asus-fan-control.nix
  ];
}
