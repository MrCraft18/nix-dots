{
    description = "Should be a System Flake";

    outputs = { self, nixpkgs, home-manager, nix-on-droid, ... } @inputs: {
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
                    ./modules/stylix
                    # ./modules/i3
                    ./modules/zsh
                    ./modules/git
                    ./modules/password-store
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/kitty
                    ./modules/zellij
                    ./modules/retroarch
                    ./modules/ssh-client
                    ./modules/localxpose
                    ./modules/syncthing
                    ./modules/sops
                ];
            };

            netbook = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };

                    overlays = [
                        (self: super: {
                            pinentry-rofi = super.pinentry-rofi.overrideAttrs (old: {
                                postInstall = ''
                                    wrapProgram $out/bin/pinentry-rofi --prefix PATH : ${
                                        super.lib.makeBinPath [
                                            super.rofi-wayland
                                            super.coreutils
                                        ]
                                    }
                                '';
                            });
                        })
                    ];
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

                    # {
                    #     specialisation = {
                    #         hyprland.configuration = {
                    #             imports = [ ./modules/hyprland ];
                    #             environment.etc."specialisation".text = "hyprland";
                    #         };
                    #
                    #
                    #         i3.configuration = {
                    #             imports = [ ./modules/i3 ];
                    #             environment.etc."specialisation".text = "i3";
                    #         };
                    #     };
                    # }

                    ./hosts/netbook

                    # Used Modules
                    ./modules/hyprland
                    ./modules/stylix
                    # ./modules/i3
                    ./modules/git
                    ./modules/password-store
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/kitty
                    ./modules/zellij
                    ./modules/ssh-client
                    ./modules/localxpose
                    ./modules/syncthing
                    ./modules/sops
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
                    ./modules/git
                    ./modules/password-store
                    ./modules/yazi
                    ./modules/stylix
                    ./modules/kitty
                    ./modules/zellij
                    ./modules/retroarch
                    ./modules/ssh-client
                    ./modules/localxpose
                    ./modules/syncthing
                    ./modules/sops
                ];
            };

            panasonic = nixpkgs.lib.nixosSystem {
                pkgs = import nixpkgs {
                    system = "x86_64-linux";
                    config = { allowUnfree = true; };

                    overlays = [
                        (self: super: {
                            pinentry-rofi = super.pinentry-rofi.overrideAttrs (old: {
                                postInstall = ''
                                    wrapProgram $out/bin/pinentry-rofi --prefix PATH : ${
                                        super.lib.makeBinPath [
                                            super.rofi-wayland
                                            super.coreutils
                                        ]
                                    }
                                '';
                            });
                        })
                    ];
                };
                specialArgs = {
                    inherit inputs;
                    host = "panasonic";
                    buildScope = "nixos";
                };
                modules = [
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "panasonic";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/panasonic

                    # Used Modules
                    ./modules/hyprland
                    ./modules/stylix
                    ./modules/git
                    ./modules/password-store
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/kitty
                    ./modules/zellij
                    ./modules/ssh-client
                    ./modules/sops
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
                    ./modules/ssh-client
                    ./modules/localxpose
                    ./modules/sops
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
                    # ./modules/yazi
                    ./modules/localxpose
                    ./modules/sops
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
                    home-manager.nixosModules.home-manager
                    { 
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            host = "chromebook-b";
                            buildScope = "nixos";
                        };
                    }

                    ./hosts/chromebook-b

                    # Used Modules
                    ./modules/zsh
                    ./modules/nvf
                    ./modules/yazi
                    ./modules/localxpose
                    ./modules/sops
                ];
            };
        };  

        homeConfigurations = {
            "craft" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                };
                extraSpecialArgs = {
                    inherit inputs;
                    buildScope = "home-manager";
                };
                modules = [
                    ./hosts/commom/home.nix
                    ./modules/nvf
                ];
            };
        };

        nixOnDroidConfigurations = {
            default = nix-on-droid.lib.nixOnDroidConfiguration {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config = { allowUnfree = true; };
                    overlays = [ nix-on-droid.overlays.default ];
                };
                extraSpecialArgs = {
                    inherit inputs;
                    host = "zflip";
                    buildScope = "nix-on-droid";
                };
                modules = [
                    { 
                        home-manager = {
                            useGlobalPkgs = true;
                            extraSpecialArgs = {
                                inherit inputs;
                                host = "zflip";
                            };
                        };
                    }

                    ./hosts/zflip

                    ./modules/zsh
                    ./modules/nvf
                    ./modules/zellij
                    ./modules/git
                    ./modules/password-store
                ];
                home-manager-path = home-manager.outPath;
            }; 
        };
    };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-hardware.url = "github:nixos/nixos-hardware";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-on-droid = {
            url = "github:nix-community/nix-on-droid";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        sops-nix = {
            url = "github:mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        stylix.url = "github:danth/stylix";

        oom-hardware.url = "github:MrCraft18/oom-hardware";

        hyprland.url = "github:hyprwm/Hyprland/v0.48.1";

        uconsole-hyprland = {
            url = "github:hyprwm/Hyprland/v0.45.2";
            inputs.aquamarine.url = "github:hyprwm/aquamarine/v0.4.4";
        };

        nvf.url = "github:NotAShelf/nvf";

        zen-browser.url = "github:0xc000022070/zen-browser-flake";

        localxpose.url = "github:MrCraft18/localxpose-flake";

        playwright-server.url = "github:MrCraft18/playwright-server";

        lobster = {
            url = "github:justchokingaround/lobster";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
