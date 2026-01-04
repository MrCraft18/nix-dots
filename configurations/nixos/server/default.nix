{ pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./disko-config.nix
        ../../../modules
        ./copyparty.nix
    ];

    moduleLoadout = {
        terminal = {
            shell = "zsh";
            multiplexer = "zellij";
            editor = "nvf";
            fileBrowser = "yazi";
        };

        programs = {
            git.enable = true;
            password-store.enable = true;
        };

        services = {
            ssh.enable = true;
            udiskie.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        copyparty
    ];

    services.openssh.settings.X11Forwarding = true;
    environment.systemPackages = [ pkgs.xorg.xauth ];

    networking.hostId = "a0235cef";

    boot.supportedFilesystems = [ "zfs" ];

    services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
    };

      boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot-efi/disk1";
    };

    boot.loader.grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;

        # no BIOS MBR install, only EFI
        devices = [ "nodev" ];
        copyKernels = true;

        # mirror EFI contents to all four ESPs
        mirroredBoots = [
            { path = "/boot-efi/disk1"; devices = [ "nodev" ]; }
            { path = "/boot-efi/disk2"; devices = [ "nodev" ]; }
            { path = "/boot-efi/disk3"; devices = [ "nodev" ]; }
            { path = "/boot-efi/disk4"; devices = [ "nodev" ]; }
        ];
    };

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
