{
  description = "Cleboost's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-dokploy = {
      url = "github:el-kurto/nix-dokploy";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };

    # cachix branch: prebuilt binaries. Do not follow nixpkgs or the cache misses.
    umbriel = {
      url = "github:noctalia-dev/umbriel/cachix";
    };

    chatgpt-desktop = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grok-bot = {
      url = "github:jordangarrison/grok-bot-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:GoByeBye/claude-desktop-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-rustdesk-pr = {
      url = "github:telometto/nixpkgs/86fb8aca9dcd694480c58b087dc73f8b1ed5d38b";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, noctalia, noctalia-greeter, umbriel, ... }@inputs:
    let
      username = "cleboost";

      desktopHosts = [
        "cleboost-sage"
        "cleboost-brain"
      ];

      serverHosts = [
        "vps-assosite"
      ];

      mkDesktopHost = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostName username; };
        modules = [
          ./hosts/${hostName}
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
          umbriel.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs hostName username; };
            home-manager.users.${username} = import ./home/default.nix;
          }
        ];
      };

      mkServerHost = hostName: nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostName username; };
        modules = [
          ./hosts/${hostName}
          inputs.nix-dokploy.nixosModules.default
          home-manager-stable.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs hostName username; };
            home-manager.users.${username} = import ./home/server.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations =
        nixpkgs.lib.genAttrs desktopHosts mkDesktopHost
        // nixpkgs.lib.genAttrs serverHosts mkServerHost;

      packages.x86_64-linux = {
        pdfcraft =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/pkgs/pdfcraft.nix { };
        codex-chatgpt-web =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/pkgs/codex-chatgpt-web.nix { };
        antigravity-cli =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/pkgs/antigravity-cli.nix { };
        rakazo =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/pkgs/rakazo.nix { };
      };
    };
}
