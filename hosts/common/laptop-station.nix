{ pkgs, config, inputs, ... }:

{
    #Auto Login User
    services.getty.autologinUser = "craft";
    services.logind = {
        lidSwitch = "ignore";
        lidSwitchExternalPower = "ignore";
        lidSwitchDocked = "ignore";
    };
    systemd.sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowHybridSleep=no
        AllowSuspendThenHibernate=no
    '';

    services.tailscale.enable = true;

    services.openssh = {
        enable = true;
        ports = [ 3500 ];
        settings = {
            PasswordAuthentication = false;
            X11Forwarding = true;
        };
    };

    networking.firewall.allowedTCPPorts = [ 3501 ];

    systemd.services.scraping-client = {
        description = "REventures scraping agent";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
            Type = "forking";

            ExecStart = ''${pkgs.tmux}/bin/tmux -L scraping-client new -d "nix develop '#scrape-client' --command node scraping/index.js"'';
            ExecStop = "${pkgs.tmux}/bin/tmux -L scraping-client kill-session";
            WorkingDirectory = "/home/craft/REventures";
            Restart = "on-failure";
            RestartSec = 10;
            KillMode = "control-group";
            User = "craft";
        };
    };
}
