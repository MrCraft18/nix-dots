{ config, lib, pkgs, inputs, ... }:

{
    imports = [
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
        };
    };

    stylix = {
        enable = true;
        homeManagerIntegration.followSystem = false;
    };

    # Simply install just the packages
    environment.packages = with pkgs; [
        # User-facing stuff that you really really want to have
        home-manager
        vim # or some other editor, e.g. nano or neovim
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

        # Some common stuff that people expect to have
        #procps
        killall
        diffutils
        findutils
        utillinux
        #tzdata
        hostname
        man
        gnugrep
        tar
        #gnupg
        #gnused
        #gnutar
        #bzip2
        #gzip
        #xz
        #zip
        #unzip
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

    user.shell = "${pkgs.zsh}/bin/zsh";

    # Backup etc files instead of failing to activate generation if a file already exists in /etc
    environment.etcBackupExtension = ".bak";

    # Read the changelog before changing this value
    system.stateVersion = "24.05";

    # Set up nix for flakes
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    environment.etc."resolv.conf".text = lib.mkForce ''
        nameserver 100.100.100.100
    '';

    terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf";

    home-manager = {
        config = {
            home.username = "nix-on-droid";
            home.homeDirectory = "/data/data/com.termux.nix/files/home";

            home.stateVersion = "24.05";
        };
    };
}
