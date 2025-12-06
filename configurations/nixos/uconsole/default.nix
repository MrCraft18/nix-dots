{ inputs, lib, pkgs, modulesPath, ... }:

{
    imports = [
        (lib.mkAliasOptionModule [ "environment" "checkConfigurationOptions" ] [ "_module" "check" ])
        inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
        inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.bluetooth
        inputs.oom-hardware.nixosModules.uconsole
        inputs.oom-hardware.nixosModules.uc.kernel
        inputs.oom-hardware.nixosModules.uc.configtxt
        inputs.oom-hardware.nixosModules.uc.base-cm4
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
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
        qutebrowser
    ];

    boot.loader.raspberryPi.bootloader = "kernel";
    boot.consoleLogLevel = 7;

    console = {
        earlySetup = true;
        font = "ter-v32n";
        packages = with pkgs; [ terminus_font ];
    };

    disabledModules = [ (modulesPath + "/rename.nix") ];

    boot.loader.systemd-boot.enable = false;

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
