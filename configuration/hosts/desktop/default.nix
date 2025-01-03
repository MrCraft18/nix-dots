{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/common.nix
        ../../modules/hyprland+tuigreet.nix
        ../../modules/zsh.nix
    ];

    # Bootloader Stuff
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "desktop";

    environment.systemPackages = [

    ];


# services.openssh.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
