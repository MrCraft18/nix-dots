{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../../modules
    ];

    moduleLoadout = {
        desktop = "hyprland-onedarkpro";
        greeter = "tui";

        terminal = {
            emulator = "kitty";
            shell = "zsh";
            multiplexer = "zellij";
            editor = "nvf";
            fileBrowser = "yazi";
        };

        applications = {
            zen-browser.enable = true;
            retroarch.enable = true;
            steam.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
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
        blender
        firefox
        vdhcoapp
        winetricks
        vesktop
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
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # networking.firewall.allowedTCPPorts = [ 6930 ];

    system.stateVersion = "24.05";
    home-manager.users.craft.home.stateVersion = "24.05";
}
