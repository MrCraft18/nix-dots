# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
# Use Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "fbcon=rotate:1" ];

#Network
    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

#Enable Bluetooth
    hardware.bluetooth.enable = true;

#PipeWire
    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

# Set your time zone.
    time.timeZone = "America/Chicago";

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

# Hyprland
    programs.hyprland.enable = true;
    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "${pkgs.hyprland}/bin/Hyprland";
                user = "user";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
                user = "greeter";
            };
        };
    };


# Use Zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

# Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.user = {
        isNormalUser = true;
        description = "Caden Edwards";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            yaru-theme
        ];
    };

# Enable automatic login for the user.
# services.getty.autologinUser = "user";

# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = [
        pkgs.firefox
        pkgs.zoxide
        pkgs.neovim
        pkgs.btop
        pkgs.git
        pkgs.kitty
        pkgs.bluez
        pkgs.ripgrep
        pkgs.gcc
        pkgs.wl-clipboard
        pkgs.bat
        pkgs.waybar
        pkgs.gh
        inputs.zen-browser.packages.x86_64-linux.specific
    ];

    fonts.packages = with pkgs; [
        nerdfonts
    ];

    environment.variables = {
        EDITOR = "nvim";
    };

    # environment.shellAliases = {
    #     z = "zoxide";
    # };

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
