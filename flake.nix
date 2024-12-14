{
    description = "Should be a System Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser.url = "github:ch4og/zen-browser-flake";
    };

    outputs = { self, nixpkgs, home-manager, ... } @inputs: 
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
        };
    in {
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/netbook/configuration.nix
                ];
            };
        };  

        homeConfigurations = {
            user = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home.nix ];
            };  
        };
    };
}
