{ pkgs, username ? "cleboost", ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Cleboost";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "adbusers"
      "docker"
      "dialout"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
