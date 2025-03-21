{
    description = "Should be a System Flake";

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
                    # ./modules/i3
                    ./modules/zsh
                    # ./modules/nvim
                    ./modules/nvf
                    ./modules/yazi
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
                    # ./modules/i3
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/kitty
                ];
            };

            uconsole = nixpkgs.lib.nixosSystem {
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
                            host = "uconsole";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/uconsole

                    # Used Modules
                    ./modules/hyprland
                    ./modules/zsh
                    # ./modules/nvim
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/kitty
                    ./modules/retroarch
                ];
            };

            old-laptop = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "old-laptop";
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "old-laptop";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/old-laptop

                    # Used Modules
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                ];
            };

            chromebook-a = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "chromebook-a";
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "chromebook-a";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/chromebook-a

                    # Used Modules
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                ];
            };

            chromebook-b = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };
                };
                specialArgs = {
                    inherit inputs;
                    host = "chromebook-b";
                    buildScope = "nixos";
                };
                modules = [
                    # home-manager.nixosModules.home-manager
                    # { 
                    #     home-manager.extraSpecialArgs = {
                    #         inherit inputs;
                    #         host = "chromebook-b";
                    #         buildScope = "nixos";
                    #     };
                    # }

                    ./hosts/chromebook-b

                    # Used Modules
                    # ./modules/zsh
                    # ./modules/nvf
                    # ./modules/yazi
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

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland/v0.46.2";

        uconsole-kernel-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable/3566ab7246670a43abd2ffa913cc62dad9cdf7d5";

        oom-hardware.url = "https://github.com/robertjakub/oom-hardware";

        uconsole-hyprland = {
            url = "github:hyprwm/Hyprland/v0.45.2";
            inputs.aquamarine.url = "github:hyprwm/aquamarine/v0.4.4";
        };

        nvf.url = "github:NotAShelf/nvf";

        zen-browser.url = "github:0xc000022070/zen-browser-flake";
    };
}
