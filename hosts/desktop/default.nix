{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    # Bootloader Stuff
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Set System Name
    networking.hostName = "desktop";

    # Extra system relavent home-manager config
    home-manager.users.craft = {
        home.packages = with pkgs; [
            prismlauncher
            suyu
            # bottles
            wineWowPackages.unstableFull
        ] ++ [
            inputs.umu.packages.${pkgs.system}.umu
        ];
    };

    # Mount my SSD
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.ntfs3g ];
    fileSystems."/mnt/SSD" = {
        device = "/dev/sda1";
        fsType = "ntfs-3g"; 
        options = [ "rw" ];
    };

    # Nvidia Stupidity
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Just in case something needs this
    hardware.graphics.enable32Bit = true;

    # Wish this was in home-manager :(
    programs.steam.enable = true;

    # For dumb GUIs that need this
    programs.dconf.enable = true;


# services.openssh.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
