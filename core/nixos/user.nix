{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  isServer = config.cleboost.server;
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw6GmxrctPQwp8QsVbj/IM4MFJ2xlz+j0vfEzgFu33i"
  ];
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ]
    ++ lib.optionals (!isServer) [
      "video"
      "input"
      "adbusers"
      "dialout"
    ];
    openssh.authorizedKeys.keys = lib.mkIf isServer sshKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = lib.mkIf isServer sshKeys;

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
