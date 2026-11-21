{
  config,
  lib,
  pkgs,
  ...
}:

let
  isServer = config.cleboost.server;
in
{
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    kernelPackages = if isServer then pkgs.linuxPackages else pkgs.linuxPackages_xanmod_latest;
    tmp.cleanOnBoot = true;

    kernel.sysctl =
      {
        "vm.swappiness" = if isServer then 60 else 180;
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
      }
      // lib.optionalAttrs (!isServer) {
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.max_map_count" = 2147483642;
      };
  };
}
