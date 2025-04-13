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
            useOSProber = true;
        };
    };

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
        };
    };

    services.tailscale.enable = true;

    # Extra system relavent home-manager config
    home-manager.users.craft = {
        home.packages = with pkgs; [
            firefox
            winetricks
            wineWowPackages.unstableFull
            umu-launcher
            vesktop
            mongodb-compass
        ] ++ [
            inputs.zen-browser.packages.${pkgs.system}.default
        ];

        # TEMPORARYISH?
        programs.mpv.enable = true;
        programs.mpv.config = {
            volume-max = 300;
        };
    };

    programs.steam.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
