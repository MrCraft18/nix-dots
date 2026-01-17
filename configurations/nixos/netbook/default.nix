{ inputs, pkgs, ... }:

{
    imports = [
        inputs.nixos-hardware.nixosModules.gpd-pocket-3
        ./hardware-configuration.nix
        ../../../modules
    ];

    moduleLoadout = {
        desktop = "hyprland-onedarkpro";
        greeter = "tui";

        terminal = {
            emulator = "kitty";
            shell = "zsh";
            multiplexer = "zellij";
            editor = "nvf";
            fileBrowser = "yazi";
        };

        applications = {
            zen-browser.enable = true;
            vesktop.enable = true;
            steam.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
        };

        services = {
            ssh.enable = true;
            desksync.enable = true;
            # udiskie.enable = true;
        };
    };

    # Extra system relavent home-manager config
    home-manager.users.craft.home.packages = with pkgs; [
        firefox
        winetricks
        wineWowPackages.unstableFull
        umu-launcher
        mongodb-compass
        anki
        prismlauncher
        obs-studio
        obs-studio-plugins.wlrobs
    ];

    home-manager.users.craft.imports = [
        ({ config, ... }: {
            sops.secrets."copyparty_craft_password" = {
                sopsFile = "${inputs.self}/secrets.yaml";
            };

            sops.templates."rclone-copyparty-headers".content = ''
                Cookie,cppwd=${config.sops.placeholder."copyparty_craft_password"}
            '';

            programs.rclone = {
                enable = true;

                remotes = {
                    "cpp-rw" = {
                        config = {
                            type = "webdav";
                            vendor = "owncloud";
                            url = "http://server:3210/";
                            pacer_min_sleep = "0.01ms";
                        };

                        secrets.headers = config.sops.templates."rclone-copyparty-headers".path;

                        mounts."/" = {
                            enable = true;
                            mountPoint = "${config.home.homeDirectory}/copyparty";
                            options = {
                                "vfs-cache-mode" = "full";
                                "vfs-cache-max-age" = "5s";
                                "attr-timeout" = "5s";
                                "dir-cache-time" = "5s";
                            };
                        };
                    };
                };
            };

            systemd.user.services."rclone-mount:.@cpp-rw".Unit = {
                After = [ "rclone-config.service" ];
                Wants = [ "rclone-config.service" ];
            };
        })
    ];

    hardware.sensor.iio.enable = true;

    nixpkgs.overlays = [
        (final: prev: {
            wvkbd = prev.wvkbd.overrideAttrs (old: {
                src = prev.fetchFromGitHub {
                    owner = "greymouser";
                    repo = "wvkbd";
                    rev = "master";
                    hash = "sha256-86MoNjwl0/O4F/5mjl8aFo1wZjnkqTK2kRZgQhTFC/I=";
                };
            });
        })
    ];

    system.stateVersion = "24.05";
    home-manager.users.craft.home.stateVersion = "24.05";
}
