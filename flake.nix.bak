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

    hm-pr-zapfast = {
      url = "github:nix-community/home-manager/pull/10178/head";
      flake = false;
    };

    nix-dokploy = {
      url = "github:el-kurto/nix-dokploy";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter/cachix";
    };

    # cachix branch: prebuilt binaries. Do not follow nixpkgs or the cache misses.
    umbriel = {
      url = "github:noctalia-dev/umbriel/cachix";
    };

    luciole = {
      url = "github:noctalia-dev/luciole";
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

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
      noctalia,
      noctalia-greeter,
      umbriel,
      luciole,
      ...
    }@inputs:
    let
      username = "cleboost";

      desktopHosts = [
        "cleboost-sage"
        "cleboost-brain"
      ];

      serverHosts = [
        "vps-assosite"
      ];

      mkHost =
        {
          nixpkgsInput ? nixpkgs,
          homeManagerInput ? home-manager,
          extraModules ? [ ],
        }:
        hostName:
        nixpkgsInput.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hostName username; };
          modules = [
            ./hosts/${hostName}
            ./core/nixos
            homeManagerInput.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;
                extraSpecialArgs = { inherit inputs hostName username; };
                users.${username} = import ./core/home;
              };
            }
          ]
          ++ extraModules;
        };

      mkDesktopHost = mkHost {
        extraModules = [
          ./core/nixos/_desktop.nix
          ./core/nixos/services/_noctalia.nix
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
          umbriel.nixosModules.default
          luciole.nixosModules.default
        ];
      };

      mkServerHost = mkHost {
        nixpkgsInput = nixpkgs-stable;
        homeManagerInput = home-manager-stable;
        extraModules = [
          inputs.nix-dokploy.nixosModules.default
          inputs.disko.nixosModules.disko
        ];
      };
    in
    {
      nixosConfigurations =
        nixpkgs.lib.genAttrs desktopHosts mkDesktopHost // nixpkgs.lib.genAttrs serverHosts mkServerHost;

      packages.x86_64-linux = {
        codex-chatgpt-web =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/codex-chatgpt-web.nix
            { };
        antigravity-cli =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/antigravity-cli.nix
            { };
        rakazo = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/rakazo.nix { };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
