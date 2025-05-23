{ inputs, config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./uConsole.nix
        ../common/configuration.nix
        ../common/tuigreet.nix
    ];

    # nix.settings = {
    #     substituters = [ "https://hyprland.cachix.org" ];
    #     trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    # };


    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;

    environment.systemPackages = with pkgs; [
        tmux
    ];

    # Extra system relavent home-manager config
    home-manager.users.craft = {
        home.packages = with pkgs; [
            vesktop
            mongodb-compass
            ngrok
        ] ++ [
            inputs.zen-browser.packages.${pkgs.system}.default
        ];
    };

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = true;
        };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
}
