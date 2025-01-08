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

    outputs = { self, nixpkgs, home-manager, ... } @inputs:{
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "desktop";
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "desktop";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/desktop

                    # Used Modules
                    ./modules/hyprland
                    ./modules/nvim
                    ./modules/kitty
                    ./modules/retroarch
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
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "netbook";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/netbook

                    # Used Modules
                    ./modules/hyprland
                    ./modules/nvim
                    ./modules/kitty
                ];
            };

            uconsole = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "uconsole";
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            pkgs = import nixpkgs {
                                system = "aarch64-linux";
                                config = { allowUnfree = true; };
                            };
                            host = "uconsole";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/uconsole

                    # Used Modules
                    ./modules/hyprland
                    ./modules/nvim
                    ./modules/kitty
                    ./modules/retroarch
                ];
            };
        };  

        homeConfigurations = {
            # "craft@desktop" = home-manager.lib.homeManagerConfiguration {
            #     pkgs = import nixpkgs {
            #         system = "x86_64-linux";
            #         config = { allowUnfree = true; };
            #     };
            #     extraSpecialArgs = {
            #         inherit inputs;
            #         host = "desktop";
            #     };
            #     modules = [ ./home.nix ];
            # };
            #
            # "user@netbook" = home-manager.lib.homeManagerConfiguration {
            #     pkgs = import nixpkgs {
            #         system = "x86_64-linux";
            #         config = { allowUnfree = true; };
            #     };
            #     extraSpecialArgs = {
            #         inherit inputs;
            #         host = "netbook";
            #     };
            #     modules = [ ./home.nix ];
            # };
            #
            # "user@uconsole" = home-manager.lib.homeManagerConfiguration {
            #     pkgs = import nixpkgs {
            #         system = "aarch64-linux";
            #         config = { allowUnfree = true; };
            #     };
            #     extraSpecialArgs = {
            #         inherit inputs;
            #         host = "uconsole";
            #     };
            #     modules = [ ./home.nix ];
            # };
        };
    };
}
