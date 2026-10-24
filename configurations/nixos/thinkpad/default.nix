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
            multiplexer = "tmux";
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
            # desksync.enable = true;
            ssh.enable = true;
            udiskie.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        firefox
        umu-launcher
        mongodb-compass
        prismlauncher
        blender
        (let
            pname = "freecad";
            version = "26.3rc2";
            src = fetchurl {
                url = "https://github.com/FreeCAD/FreeCAD/releases/download/${version}/FreeCAD_${version}-Linux-x86_64.AppImage";
                sha256 = "2cf4212d5a348574e786da7d5a8faeeb3e83dd4245c23898dede92ce82ce4908";
            };
            appimageContents = appimageTools.extract {
                inherit pname version src;
            };
        in appimageTools.wrapType2 {
            inherit pname version src;
            extraInstallCommands = ''
                install -Dm444 ${appimageContents}/org.freecad.FreeCAD.desktop \
                    $out/share/applications/org.freecad.FreeCAD.desktop
                substituteInPlace $out/share/applications/org.freecad.FreeCAD.desktop \
                    --replace-fail 'Exec=AppRun' 'Exec=freecad'
                install -Dm444 ${appimageContents}/org.freecad.FreeCAD.svg \
                    $out/share/icons/hicolor/scalable/apps/org.freecad.FreeCAD.svg
            '';
            meta = {
                description = "Parametric 3D CAD modeler (26.3 release candidate)";
                homepage = "https://www.freecad.org/";
                license = lib.licenses.lgpl2Plus;
                platforms = [ "x86_64-linux" ];
                mainProgram = "freecad";
            };
        })
        obs-studio
        obs-studio-plugins.wlrobs
        (let
            pname = "tinywiibackupmanager";
            version = "6.1.7";
            src = fetchurl {
                url = "https://github.com/mq1/TinyWiiBackupManager/releases/download/v${version}/TinyWiiBackupManager-v${version}-linux-x86_64.AppImage";
                hash = "sha256-ib5vq6SMTdjXjfgCyJ++7TtY+aCH1h3TK/hYq+k8iZQ=";
            };
            appimageContents = appimageTools.extract {
                inherit pname version src;
            };
        in appimageTools.wrapType2 {
            inherit pname version src;
            extraInstallCommands = ''
                install -Dm444 ${appimageContents}/it.mq1.TinyWiiBackupManager.desktop \
                    $out/share/applications/it.mq1.TinyWiiBackupManager.desktop
                substituteInPlace $out/share/applications/it.mq1.TinyWiiBackupManager.desktop \
                    --replace-fail 'Exec=TinyWiiBackupManager' 'Exec=tinywiibackupmanager'
                install -Dm444 ${appimageContents}/it.mq1.TinyWiiBackupManager.png \
                    $out/share/icons/hicolor/256x256/apps/it.mq1.TinyWiiBackupManager.png
            '';
            meta = {
                description = "A tiny game backup and homebrew app manager for the Wii";
                homepage = "https://github.com/mq1/TinyWiiBackupManager";
                license = lib.licenses.gpl3Only;
                platforms = [ "x86_64-linux" ];
                mainProgram = "tinywiibackupmanager";
            };
        })
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

    services.keyd = {
        enable = true;
        keyboards.default = {
            ids = [ "*" ];
            settings.main = {
                capslock = "esc";
                sysrq = "rightmeta";
            };
        };
    };

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
