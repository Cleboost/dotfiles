{ lib, config, ... }:

let
  cfg = config.drivers.vm;
in
{
  options.drivers.vm = {
    enable = lib.mkEnableOption "Virtual Machine Guest Services (QEMU & SPICE)";
  };

  config = lib.mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
