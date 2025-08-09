{ inputs, config, pkgs, ... }:

{
    imports = [
        inputs.nixos-hardware.nixosModules.gpd-pocket-3
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    boot.loader = {
        systemd-boot.enable = false;
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            # useOSProber = true;
        };
    };

    
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
        };
    };

    services.tailscale.enable = true;

    # Extra system relavent home-manager config
    home-manager.users.craft = {
        imports = [
            inputs.zen-browser.homeModules.beta
        ];

        home.packages = with pkgs; [
            firefox
            winetricks
            wineWowPackages.unstableFull
            umu-launcher
            vesktop
            mongodb-compass
            anki
        ] ++ [
            inputs.lobster.packages.${pkgs.system}.lobster
        ];

        programs.zen-browser  = {
            enable = true;

            profileVersion = null;

            profiles."default" = {
                id = 0;
                isDefault = true;
            };
        };

        # TEMPORARYISH?
        programs.mpv.enable = true;
        programs.mpv.config = {
            volume-max = 300;
        };
    };

    programs.steam.enable = true;
    programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
