{ inputs, ... }:

{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.disko
        ./sops/configuration.nix
        ./bluetooth.nix
        ./boot.nix
        ./fonts.nix
        ./home-manager.nix
        ./networking.nix
        ./nix.nix
        ./pipewire.nix
        ./user.nix
    ];

    services.tailscale.enable = true;

    services.automatic-timezoned.enable = true;
    services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

    i18n.defaultLocale = "en_US.UTF-8";
}
