{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/laptop-station.nix
    ];

    systemd.services.JVF-index = {
        description = "JVF scraper manager agent";
        after = [ "network.target" ];

        serviceConfig = {
            ExecStart = "nix develop /home/craft/programming/JVF/ --command node index.js";
            Restart = "always";
            RestartSec = 10;
        };

        wantedBy = [ "multi-user.target" ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
