{ pkgs, inputs, ... }:

{
    imports = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./hardware-configuration.nix
        ./disko-config.nix
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
        firefox
        umu-launcher
    ];

    system.stateVersion = "25.05";
    home-manager.users.craft.home.stateVersion = "25.05";
}
