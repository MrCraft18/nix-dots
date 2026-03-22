{ inputs, lib, pkgs, ... }:

{
    imports = [
        # ./hardware-configuration.nix
        ../../../modules
    ];

    moduleLoadout = {
        desktop = "hyprland-onedarkpro";
        greeter = "tui";

        terminal = {
            emulator = "kitty";
            shell = "zsh";
            multiplexer = "tmux";
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
            opencode.enable = true;
        };

        services = {
            ssh.enable = true;
            udiskie.enable = true;
        };
    };

    home-manager.users.craft.home.packages = with pkgs; [
        qutebrowser
    ];

    services.automatic-timezoned.enable = false;
    services.timesyncd.enable = true;

    console = {
        earlySetup = true;
        font = "ter-v24n";
        packages = with pkgs; [ terminus_font ];
    };

    nix.settings = {
        substituters = [ "https://nixos-clockworkpi-uconsole.cachix.org" ];
        trusted-public-keys = [
            "nixos-clockworkpi-uconsole.cachix.org-1:6NRN3n9/r3w5ZS8/gZudW6PkPDoC3liCt/dBseICua0="
        ];
    };

    home-manager.users.craft.home.stateVersion = "25.11";
}
