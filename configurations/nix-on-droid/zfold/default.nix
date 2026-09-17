{ config, lib, pkgs, inputs, ... }:

{
    imports = [
        ../../../modules
    ];

    moduleLoadout = {
        terminal = {
            shell = "zsh";
            multiplexer = "tmux";
            editor = "nvf";
            fileBrowser = "yazi";
        };

        programs = {
            git.enable = true;
            password-store.enable = true;
                        opencode.enable = true;
        };

        services = {
            ssh.enable = true;
        };
    };

    stylix = {
        enable = true;
        homeManagerIntegration.followSystem = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
        overlays.enable = false;
        fonts = {
            monospace = {
                package = pkgs.nerd-fonts.jetbrains-mono;
                name = "JetBrainsMono Nerd Font";
            };
        };
    };

    environment.packages = with pkgs; [
        home-manager
        vim
        openssh
        git
        gh
        zsh
        which
        curl
        iputils
        iproute2
        nettools
        glib.bin
        bat
        mosh
        tmux
        lazygit

        killall
        diffutils
        findutils
        utillinux
        hostname
        man
        gnugrep
        gnutar
    ];

    android-integration = {
        am.enable = true;
        termux-open.enable = true;
        termux-open-url.enable = true;
        termux-reload-settings.enable = true;
        termux-setup-storage.enable = true;
        termux-wake-lock.enable = true;
        termux-wake-unlock.enable = true;
        xdg-open.enable = true;
    };

    user = {
        userName = "craft";
        shell = "${pkgs.zsh}/bin/zsh";
    };

    environment.etcBackupExtension = ".bak";

    system.stateVersion = "24.05";

    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    environment.etc."resolv.conf".text = lib.mkForce ''
                nameserver 1.1.1.1
                        nameserver 8.8.8.8
    '';

    home-manager = {
        useGlobalPkgs = true;
        config = {
            home.username = "craft";
            home.homeDirectory = "/data/data/com.termux.nix/files/home";
            home.stateVersion = "26.05";
        };
    };
}
