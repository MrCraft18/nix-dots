{ pkgs, inputs, host, ... }:

{
    # Enable Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Use a good Network Manager
    networking.networkmanager.enable = true;

    # Set System Name
    networking.hostName = host;

    #Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable Sound
    services.pipewire = {
        enable = true;
        wireplumber.enable = true;
        audio.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # My Timezone
    time.timeZone = "America/Chicago";

    # My Locale
    i18n.defaultLocale = "en_US.UTF-8";

    # Have a User
    users.users.craft = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlvRA8dmnopz4KqdRhC4fPGkBGKA+SnTbw9ubFSEVD4 craft@desktop"
        ];
    };

    #Auto Mount USB
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    # Basic System Level Packages
    environment.systemPackages = with pkgs; [
        btop
        git
        bluez
        bat
        p7zip
        unrar
        pulsemixer
        fastfetch

        usbutils
        udiskie
        udisks
    ];

    # Shared Home Config
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.craft = {
            programs.home-manager.enable = true;

            home.username = "craft";
            home.homeDirectory = "/home/craft"; 

            home.stateVersion = "24.05";

            home.packages = with pkgs; [
                firefox
                kitty
                gh
                winetricks
                vesktop

                # You can also create simple shell scripts directly inside your
                # configuration. For example, this adds a command 'my-hello' to your
                # environment:
                (pkgs.writeShellScriptBin "my-hello" ''
                     echo "${host}"
                '')

            ] ++ [ inputs.zen-browser.packages.${pkgs.system}.default ];
        };
    };

    # Use zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Always have Nerd Fonts
    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ]; 

    # Set Default Editor Variable
    environment.variables = {
        EDITOR = "nvim";
    };
}
