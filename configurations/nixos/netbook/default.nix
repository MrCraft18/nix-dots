{ inputs, config, pkgs, ... }:

{
    imports = [
        inputs.nixos-hardware.nixosModules.gpd-pocket-3
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
            steam.enable = true;
        };

        programs = {
            mpv.enable = true;
            git.enable = true;
            password-store.enable = true;
        };

        services = {
            ssh.enable = true;
            desksync.enable = true;
            # udiskie.enable = true;
        };
    };

    # Extra system relavent home-manager config
    home-manager.users.craft.home.packages = with pkgs; [
        firefox
        winetricks
        wineWowPackages.unstableFull
        umu-launcher
        vesktop
        mongodb-compass
        anki
        prismlauncher
        obs-studio
        obs-studio-plugins.wlrobs
    ];

    system.stateVersion = "24.05";
    home-manager.users.craft.home.stateVersion = "24.05";
}
