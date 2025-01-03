{
    description = "Should be a System Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland/v0.46.2";

        uconsole-hyprland = {
            url = "github:hyprwm/Hyprland/v0.45.2";
            inputs.aquamarine.url = "github:hyprwm/aquamarine/v0.4.4";
        };

        zen-browser.url = "github:0xc000022070/zen-browser-flake";
    };

    outputs = { self, nixpkgs, home-manager, ... } @inputs:
        let
            
        in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "desktop";
                };
                modules = [
                    ./configuration/hosts/desktop
                ];
            };

            netbook = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "netbook";
                };
                modules = [
                    ./configuration/hosts/netbook
                ];
            };

            uconsole = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "aarch63-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "uconsole";
                };
                modules = [
                    ./configuration/hosts/uconsole
                ];
            };
        };  

        homeConfigurations = {
            "user@desktop" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                extraSpecialArgs = {
                    inherit inputs;
                    host = "desktop";
                };
                modules = [ ./home.nix ];
            };

            "user@netbook" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                extraSpecialArgs = {
                    inherit inputs;
                    host = "netbook";
                };
                modules = [ ./home.nix ];
            };

            "user@uconsole" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                };
                extraSpecialArgs = {
                    inherit inputs;
                    host = "uconsole";
                };
                modules = [ ./home.nix ];
            };
        };
    };
}
