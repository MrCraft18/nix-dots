{ lib, ... }:

{
    imports = [
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

    services.automatic-timezoned.enable = lib.mkDefault true;
    services.geoclue2.geoProviderUrl = lib.mkDefault "https://api.beacondb.net/v1/geolocate";

    i18n.defaultLocale = "en_US.UTF-8";

    boot.tmp.cleanOnBoot = true;
}
