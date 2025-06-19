{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

    # Extra system relavent home-manager config
    home-manager.users.craft = {
        home.packages = with pkgs; [
            prismlauncher
            suyu
            wineWowPackages.unstableFull
            mongodb-compass
            rclone
            umu-launcher

            firefox
            winetricks
            vesktop
        ] ++ [
            inputs.zen-browser.packages.${pkgs.system}.default
        ];

        # TEMPORARYISH?
        programs.mpv.enable = true;
        programs.mpv.config = {
            volume-max = 300;
        };
    };

    services.tailscale.enable = true;

    # Mount my SSD
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.ntfs3g ];
    fileSystems."/home/craft/SSD" = {
        device = "/dev/sda1";
        fsType = "ntfs-3g"; 
        options = [ "rw" ];
    };

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
        };
    };

    # Nvidia Stupidity
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # Just in case something needs this
    hardware.graphics.enable32Bit = true;

    # Wish this was in home-manager :(
    programs.steam.enable = true;

    # For dumb GUIs that need this
    programs.dconf.enable = true;





    # services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 6930 ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
