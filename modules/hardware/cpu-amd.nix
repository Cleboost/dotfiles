{ lib, ... }: {
  flake.mod.hardware.cpu-amd = { ... }: {
    boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  };
}
