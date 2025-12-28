{ pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./disko-config.nix
        ../../../modules
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

    ];

    networking.hostId = "a0235cef";

    boot.supportedFilesystems = [ "zfs" ];

    services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
    };

    boot.loader.grub.mirroredBoots = [
        {
            path = "/boot-efi/disk1";
            devices = [ "/dev/disk/by-id/ata-ST8000AS0002-1NA17Z_Z840RBP6" ];
        }
        {
            path = "/boot-efi/disk2";
            devices = [ "/dev/disk/by-id/ata-ST8000DM004-2CX188_ZCT00FBS" ];
        }
        {
            path = "/boot-efi/disk3";
            devices = [ "/dev/disk/by-id/ata-ST8000DM004-2CX188_ZCT00FJA" ];
        }
        {
            path = "/boot-efi/disk4";
            devices = [ "/dev/disk/by-id/ata-ST8000AS0002-1NA17Z_Z840WFB1" ];
        }
    ];

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
