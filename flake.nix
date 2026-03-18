{
    description = "Should be a System Flake";

    outputs = { self, nixpkgs, home-manager, nix-on-droid, ... } @inputs:
        let
            # lib = nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

            nixosConfigurationNames = (builtins.attrNames (builtins.readDir ./configurations/nixos));
            manualConfigurations = [ "uconsole" ];
        in {
            nixosConfigurations = nixpkgs.lib.genAttrs (nixpkgs.lib.subtractLists manualConfigurations nixosConfigurationNames) (name: nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs;
                    configurationName = name;
                    buildScope = "nixos";
                };

                modules = [
                    self.nixosModules.default
                    (./configurations/nixos + "/${name}")
                ];
            }) // {
                "uconsole" = inputs.nixos-uconsole.lib.mkUConsoleSystem {
                    variant = "cm4";

                    specialArgs = {
                        inherit inputs;
                        configurationName = "uconsole";
                        buildScope = "nixos";
                    };

                    modules = [
                        ({ ... }: {
                            disabledModules = [ "${inputs.nixos-uconsole}/modules/base.nix" ];
                        })
                        self.nixosModules.default
                        ./configurations/nixos/uconsole
                    ];
                };
            };  

            # homeConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir ./configurations/home)) (name: home-manager.lib.homeManagerConfiguration {
            #     extraSpecialArgs = {
            #         inherit inputs lib;
            #         configurationName = name;
            #         buildScope = "home";
            #     };
            #
            #     modules = [ (./configurations/home + "/${name}") ];
            # });  

            nixOnDroidConfigurations = {
                default = nix-on-droid.lib.nixOnDroidConfiguration {
                    pkgs = import inputs.nix-on-droid-nixpkgs {
                        system = "aarch64-linux";
                        config = { allowUnfree = true; };
                    };

                    extraSpecialArgs = {
                        inherit inputs;
                        buildScope = "nix-on-droid";
                    };

                    modules = [
                        ./configurations/nix-on-droid/zflip
                        inputs.stylix.nixOnDroidModules.stylix
                        ({ ... }: {
                            home-manager.config.imports = [
                                self.homeManagerModules.default
                            ];
                        })
                    ];

                    home-manager-path = home-manager.outPath;
                }; 
            };

            nixosModules.default = { ... }: {
                imports = [
                    inputs.home-manager.nixosModules.home-manager
                    inputs.sops-nix.nixosModules.sops
                    inputs.disko.nixosModules.disko
                    inputs.stylix.nixosModules.stylix
                    ./modules
                ];

                home-manager.users.craft.imports = [
                    self.homeManagerModules.default
                ];
            };

            homeManagerModules.default = { ... }: {
                imports = [
                    inputs.nvf.homeManagerModules.nvf
                    inputs.sops-nix.homeManagerModules.sops
                    inputs.zen-browser.homeModules.beta
                    inputs.lan-mouse.homeManagerModules.default
                ];
            };

            packages = {
                "x86_64-linux" = {
                    build-uconsole-img = (inputs.nixos-uconsole.lib.mkUConsoleImage {
                        variant = "cm4";

                        _module.args = {
                            configurationName = "uconsole";
                            buildScope = "nixos";
                        };

                        modules = [
                            ({ ... }: {
                                disabledModules = [ "${inputs.nixos-uconsole}/modules/base.nix" ];
                            })
                            self.nixosModules.default
                            ./configurations/nixos/uconsole
                        ];
                    }).config.system.build.sdImage;
                };
            };
        };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/88d3861acdd3d2f0e361767018218e51810df8a1";

        nixos-hardware.url = "github:nixos/nixos-hardware";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko/latest";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-on-droid = {
            url = "github:nix-community/nix-on-droid";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        nix-on-droid-nixpkgs.url = "github:nixos/nixpkgs/88d3861acdd3d2f0e361767018218e51810df8a1";

        sops-nix = {
            url = "github:mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-uconsole.url = "github:nixos-uconsole/nixos-uconsole";

        stylix.url = "github:danth/stylix";

        hyprland.url = "github:hyprwm/Hyprland";

        uconsole-hyprland = {
            url = "github:hyprwm/Hyprland/v0.45.2";
            inputs.aquamarine.url = "github:hyprwm/aquamarine/v0.4.4";
        };

        iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";

        hyprgrass = {
            url = "github:horriblename/hyprgrass";
            inputs.hyprland.follows = "hyprland";
        };

        nvf.url = "github:NotAShelf/nvf";

        zen-browser.url = "github:0xc000022070/zen-browser-flake";

        lobster = {
            url = "github:justchokingaround/lobster";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lan-mouse.url = "github:feschber/lan-mouse";

        opencode.url = "github:anomalyco/opencode";

        copyparty.url = "github:9001/copyparty";

        hytale-launcher.url = "github:TNAZEP/HytaleLauncherFlake";

        sqlit = {
            url = "github:Maxteabag/sqlit";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
