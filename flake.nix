{
  description = "Cleboost's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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
      flake-parts,
      import-tree,
      noctalia,
      noctalia-greeter,
      luciole,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      let
        username = "cleboost";

      desktopHosts = [
        "cleboost-sage"
        "cleboost-brain"
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
          specialArgs = { inherit inputs hostName username; m = config.flake.modules.nixos; mod = config.flake.mod; };
          modules = [
            ./hosts/${hostName}
            homeManagerInput.nixosModules.home-manager
            config.flake.modules.nixos.core
            (nixpkgsInput.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
            {
              nixpkgs.config.allowUnfree = true;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;
                extraSpecialArgs = { inherit inputs hostName username; };
              };
            }
          ]
          ++ extraModules;
        };

      mkDesktopHost = mkHost {
        extraModules = [
          noctalia.nixosModules.default
        ];
      };
    in
    {
      imports = [ (import-tree ./modules) ];

      flake = {
        nixosConfigurations = nixpkgs.lib.genAttrs desktopHosts mkDesktopHost;

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
    );
}
