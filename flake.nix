{
  description = "Configuration NixOS modulaire et Home Manager de Cleboost";

  inputs = {
    # Nixpkgs unstable (rolling release)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia v5 Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Greeter (Écran de déverrouillage / login)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Antigravity (IDE & CLI)
    antigravity = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, antigravity, ... }@inputs: {
    nixosConfigurations.cleboost-brain = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.cleboost = import ./home;
        }
      ];
    };

    # Alias nixos vers cleboost-brain pour compatibilité
    nixosConfigurations.nixos = self.nixosConfigurations.cleboost-brain;
  };
}
