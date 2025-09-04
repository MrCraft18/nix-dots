{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules
    ];

    moduleLoadout =  {
        hostname = "desktop";

        desktop = "hyprland-onedarkpro";
        greeter = "tui";

        terminal = {
            emulator = "kitty";
            shell = "zsh";
            editor = "nvf";
            file-browser = "yazi";
        };

        applications = {
            zen-browser.enable = true;
            retroarch.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
        };

        services = {
            ssh.enable = true;
        };
    };

    # Mount my SSD
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.ntfs3g ];
    fileSystems."/home/craft/SSD" = {
        device = "/dev/sda1";
        fsType = "ntfs-3g"; 
        options = [ "rw" ];
    };
}
