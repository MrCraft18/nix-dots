{ pkgs, inputs, config, lib, host, ... }:

{
    # Enable Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Enable Boot Loader
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

    # Optimize Nix Store After Rebuild
    nix.settings.auto-optimise-store = true;

    # Use Nix Helper
    programs.nh = {
        enable = true;
        flake = "/home/craft/nix-dots";
    };

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
    # time.timeZone = "America/Chicago";
    services.automatic-timezoned.enable = true;
    services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

    # My Locale
    i18n.defaultLocale = "en_US.UTF-8";

    # Have a User
    users.users.craft = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlvRA8dmnopz4KqdRhC4fPGkBGKA+SnTbw9ubFSEVD4 craft@desktop"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlIQ73VqgtCDpdlaUcskdpRNteq6Bb6D8YnDF/enp7K craft@netbook"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQ0aiXTNegpOpD6KGZBtTIraPynYxftP0UV+L4uKSVu craft@uconsole"
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
        fzf
        sops

        usbutils
        udiskie
        udisks
    ];

    # Shared Home Config
    home-manager = {
        backupFileExtension = "hmFileBackups";
        useGlobalPkgs = true;
        useUserPackages = true;

        users.craft = {
            programs.home-manager.enable = true;

            home.username = "craft";
            home.homeDirectory = "/home/craft"; 

            home.stateVersion = "24.05";

            home.packages = with pkgs; [
                gh

                # You can also create simple shell scripts directly inside your
                # configuration. For example, this adds a command 'my-hello' to your
                # environment:
                (pkgs.writeShellScriptBin "my-hello" ''
                     echo "${host}"
                '')
                
                (pkgs.writeShellScriptBin "gen-age-keys" ''
                    mkdir -p ~/.config/sops/age && nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt && nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
                '')

            ] ++ [ 
                # inputs.localxpose.packages.${pkgs.system}.default
            ];
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
