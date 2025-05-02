{ inputs, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../common/configuration.nix
        ../common/laptop-station.nix
    ];

    systemd.services.post-processor = {
        description = "REventures post processor";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
            Type = "forking";

            ExecStart = ''${pkgs.tmux}/bin/tmux -L post-processor new -d "nix develop '#post-processing' --command node post-processing/index.js"'';
            ExecStop = "${pkgs.tmux}/bin/tmux -L post-processor kill-server";
            WorkingDirectory = "/home/craft/REventures";
            Restart = "on-failure";
            RestartSec = 10;
            KillMode = "control-group";
            User = "craft";
        };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
