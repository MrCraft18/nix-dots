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

    networking.hostName = "desktop";

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.craft.imports = [ ../../home.nix ];
    };

    # Mount my SSD
    # boot.supportedFilesystems = [ "ntfs" ];
    # fileSystems."/mnt/SSD" = {
    #     device = "/dev/sda1";
    #     fsType = "ntfs-3g"; 
    #     options = [ "rw" ];
    # };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # environment.systemPackages = with pkgs; [
    #     ntfs3g
    # ];

    # hardware.nvidia = {
    #     modesetting.enable = true;
    #
    #     open = true;
    #
    #     nvidiaSettings = true;
    #
    #     package = config.boot.kernelPackages.nvidiaPackages.stable;
    # };

    # programs.steam.enable = true;


# services.openssh.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
