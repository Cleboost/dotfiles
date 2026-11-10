{ pkgs, username ? "cleboost", ... }:

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
  };

  security.sudo.wheelNeedsPassword = false;
}
