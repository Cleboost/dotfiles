# Self-contained ISO: can be booted on a guest computer with NO disk writes.
{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
  ];

  isoImage = {
    edition = "cleboost-demo";
  };
  image.fileName = "cleboost-demo.iso";

  # The ISO supplies its own EFI/BIOS boot path and an in-memory root filesystem.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.zfs.forceImportRoot = false;

  hardware.enableAllHardware = true;

  # Start the actual Home Manager Hyprland session as the pre-created user.
  services.displayManager.noctalia-greeter.enable = lib.mkForce false;
  services.greetd.settings.default_session = lib.mkForce {
    command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
    user = "cleboost";
  };

  # Recovery TTY if the machine's graphics cannot run Hyprland.
  services.getty.autologinUser = lib.mkForce "cleboost";

  users.users.cleboost.initialHashedPassword = "";
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  # An ephemeral demo doesn't need a remotely accessible SSH service.
  services.openssh.enable = lib.mkForce false;

  # Do not point a temporary ISO to an absolute host-specific flake path.
  programs.nh.flake = lib.mkForce null;
}
