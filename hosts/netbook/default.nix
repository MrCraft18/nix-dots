{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    # Bootloader Stuff
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    #Rotate TTY Screen 90 Degrees
    boot.kernelParams = [ "fbcon=rotate:1" ];

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = true;
        };
    };


    # Extra system relavent home-manager config
    home-manager.users.craft = {
        home.packages = with pkgs; [
            firefox
            winetricks
            wineWowPackages.unstableFull
            umu-launcher
            vesktop
            mongodb-compass
            ngrok
            cloudflared
        ] ++ [
            inputs.zen-browser.packages.${pkgs.system}.default
        ];

        # TEMPORARYISH?
        programs.mpv.enable = true;
        programs.mpv.config = {
            volume-max = 300;
        };
    };

    programs.steam.enable = true;

    # services.cloudflared = {
    #     enable = true;
    #     tunnels = {
    #         "0f374c41-d3f8-4978-a056-10ebdae7e5a5" = {
    #             credentialsFile = "/home/craft/.cloudflared/cert.pem";
    #             default = "http_status:404";
    #         };
    #     };
    # };

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
