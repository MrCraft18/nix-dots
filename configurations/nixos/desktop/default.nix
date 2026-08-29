{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../../modules
        # ./manhunt-server.nix
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
            retroarch.enable = true;
            steam.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
            opencode.enable = true;
        };

        services = {
            ssh.enable = true;
            udiskie.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        prismlauncher
        mongodb-compass
        mongosh
        umu-launcher
        # inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
        blender
        firefox-bin
        winetricks
        obs-studio
        obs-studio-plugins.wlrobs
        gimp
    ];

    home-manager.users.craft.systemd.user.services.hdmi-audio-mirror = {
        Unit = {
            Description = "Mirror default audio output to NVIDIA HDMI";
            After = [ "pipewire-pulse.service" "wireplumber.service" ];
            Wants = [ "pipewire-pulse.service" "wireplumber.service" ];
        };

        Service = {
            Type = "simple";
            ExecStart = pkgs.writeShellScript "hdmi-audio-mirror" ''
                mirror_sink="default-with-hdmi"
                hdmi_sink="alsa_output.pci-0000_26_00.1.hdmi-stereo"
                primary_sink=""
                mirrored_primary=""

                sink_exists() {
                    while read -r _ sink _; do
                        [ "$sink" = "$1" ] && return 0
                    done < <(${pkgs.pulseaudio}/bin/pactl list short sinks)

                    return 1
                }

                unload_mirror() {
                    while read -r module name args; do
                        if [ "$name" = "module-combine-sink" ] && [[ "$args" == *"sink_name=$mirror_sink"* ]]; then
                            ${pkgs.pulseaudio}/bin/pactl unload-module "$module" || true
                        fi
                    done < <(${pkgs.pulseaudio}/bin/pactl list short modules)
                }

                choose_primary_sink() {
                    local default_sink
                    default_sink="$(${pkgs.pulseaudio}/bin/pactl get-default-sink || true)"

                    if [ "$default_sink" != "$mirror_sink" ] && [ "$default_sink" != "$hdmi_sink" ] && sink_exists "$default_sink"; then
                        primary_sink="$default_sink"
                        return
                    fi

                    if [ -n "$primary_sink" ] && sink_exists "$primary_sink"; then
                        return
                    fi

                    while read -r _ sink _; do
                        if [ "$sink" != "$mirror_sink" ] && [ "$sink" != "$hdmi_sink" ]; then
                            primary_sink="$sink"
                            return
                        fi
                    done < <(${pkgs.pulseaudio}/bin/pactl list short sinks)

                    primary_sink=""
                }

                update_mirror() {
                    local default_sink

                    if ! ${pkgs.pulseaudio}/bin/pactl set-card-profile alsa_card.pci-0000_26_00.1 output:hdmi-stereo; then
                        return 1
                    fi

                    choose_primary_sink
                    default_sink="$(${pkgs.pulseaudio}/bin/pactl get-default-sink || true)"

                    if [ -z "$primary_sink" ] || ! sink_exists "$hdmi_sink"; then
                        return 1
                    fi

                    if [ "$primary_sink" = "$mirrored_primary" ] && sink_exists "$mirror_sink"; then
                        if [ "$default_sink" != "$mirror_sink" ]; then
                            ${pkgs.pulseaudio}/bin/pactl set-default-sink "$mirror_sink"
                        fi

                        return 0
                    fi

                    unload_mirror

                    if ${pkgs.pulseaudio}/bin/pactl load-module module-combine-sink sink_name="$mirror_sink" slaves="$primary_sink,$hdmi_sink" \
                        && ${pkgs.pulseaudio}/bin/pactl set-default-sink "$mirror_sink"; then
                        mirrored_primary="$primary_sink"
                        return 0
                    fi

                    return 1
                }

                for _ in {1..20}; do
                    if update_mirror; then
                        break
                    fi

                    ${pkgs.coreutils}/bin/sleep 1
                done

                ${pkgs.pulseaudio}/bin/pactl subscribe | while read -r _; do
                    update_mirror || true
                done
            '';

            Restart = "always";
            RestartSec = 2;
        };

        Install.WantedBy = [ "default.target" ];
    };

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
