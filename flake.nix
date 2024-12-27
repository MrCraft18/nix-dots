{
    description = "Should be a System Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        uconsole-hyprland = {
            url = "github:hyprwm/Hyprland/v0.45.2";
            inputs.aquamarine.url = "github:hyprwm/aquamarine/v0.4.4";
        };

        zen-browser.url = "github:ch4og/zen-browser-flake";
    };

    outputs = { self, nixpkgs, home-manager, ... } @inputs: {
        nixosConfigurations = {
            netbook = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = { inherit inputs; };
                modules = [
                    ./configuration/hosts/netbook
                ];
            };

            uconsole = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = { inherit inputs; };
                modules = [
                    ./configuration/hosts/uconsole
                ];
            };
        };  

        homeConfigurations = {
            user = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                };
                modules = [ ./home.nix ];
            };  
        };
    };
}
