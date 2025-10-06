{ pkgs, configurationName, ... }:

{
    networking = {
        hostName = configurationName;
        networkmanager = {
            enable = true;
            settings.main.autoconnect-retries-default = 0;
        };

        firewall.enable = false;
    };

    environment.systemPackages = [ pkgs.net-tools ];
}
