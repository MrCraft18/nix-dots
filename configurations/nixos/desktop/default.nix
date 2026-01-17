{ inputs, config, pkgs, ... }:

{
    imports = [
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
            retroarch.enable = true;
            steam.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
            codex.enable = true;
            opencode.enable = true;
        };

        services = {
            ssh.enable = true;
            udiskie.enable = true;
            desksync.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        prismlauncher
        mongodb-compass
        mongosh
        umu-launcher
        blender
        firefox
        vdhcoapp
        winetricks
        obs-studio
        obs-studio-plugins.wlrobs
        gimp
    ] ++ [
        inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
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

    # Support emulated building for aarch64
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

    # Mount my SSD
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.ntfs3g ];
    fileSystems."/home/craft/SSD" = {
        device = "/dev/sda1";
        fsType = "ntfs-3g"; 
        options = [ "rw" ];
    };

    # Nvidia Stupidity
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        # package = config.boot.kernelPackages.nvidiaPackages.production;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "580.95.05";
            sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
            sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
            openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
            settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
            persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
        };
    };

    # networking.firewall.allowedTCPPorts = [ 6930 ];

    system.stateVersion = "24.05";
    home-manager.users.craft.home.stateVersion = "24.05";
}
