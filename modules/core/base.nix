{ inputs, ... }: {
  flake.modules.nixos.core = { lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "cleboost" ])
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    };
    hm.home.stateVersion = "24.11";

    users.users.cleboost = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "fr_FR.UTF-8";
    console.keyMap = "fr";

    networking.networkmanager.enable = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    programs.nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/cleboost/dotfiles";
    };
  };
}
