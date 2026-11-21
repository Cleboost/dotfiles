{ pkgs, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages;
    tmp.cleanOnBoot = true;

    kernel.sysctl = {
      "vm.swappiness" = 60;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
    };
  };
}
