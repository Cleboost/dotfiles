{
  pkgs,
  username ? "cleboost",
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Cleboost";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw6GmxrctPQwp8QsVbj/IM4MFJ2xlz+j0vfEzgFu33i"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw6GmxrctPQwp8QsVbj/IM4MFJ2xlz+j0vfEzgFu33i"
  ];

  security.sudo.wheelNeedsPassword = false;
}
