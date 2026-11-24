{ ... }: {
  flake.modules.nixos.docker = { pkgs, username, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    users.users.${username}.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.docker-compose ];
  };
}
