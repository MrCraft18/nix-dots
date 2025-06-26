{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    boot.loader = {
        systemd-boot.enable = false;
        grub = {
            enable = true;
            device = "/dev/sda";
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
            mongodb-compass
        ] ++ [
            inputs.zen-browser.packages.${pkgs.system}.default
            inputs.lobster.packages.${pkgs.system}.lobster
        ];
    };

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
