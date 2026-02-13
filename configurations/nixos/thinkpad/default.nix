{ pkgs, inputs, ... }:

{
    imports = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./hardware-configuration.nix
        ./disko-config.nix
        # ../../../modules
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
        };

        programs = {
            git.enable = true;
            password-store.enable = true;
            mpv.enable = true;
            opencode.enable = true;
        };

        services = {
            desksync.enable = true;
            ssh.enable = true;
            udiskie.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        firefox
        umu-launcher
        mongodb-compass
        prismlauncher
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

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
