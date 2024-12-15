{ config, pkgs, ... }:

{
    # Enable Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Use a good Network Manager
    networking.networkmanager.enable = true;

    #Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable Sound
    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    # My Timezone
    time.timeZone = "America/Chicago";

    # My Locale
    i18n.defaultLocale = "en_US.UTF-8";

    # Have a User
    users.users.user = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
    };

    # Basic Packages
    environment.systemPackages = with pkgs; [
        neovim
        btop
        git
        bluez
        bat
    ];

    # Always have Nerd Fonts
    # fonts.packages = with pkgs; [
    #     nerdfonts
    # ];

    # Set Default Editor Variable
    environment.variables = {
        EDITOR = "nvim";
    };
}
