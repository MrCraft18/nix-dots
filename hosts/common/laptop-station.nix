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
        };
    };

    networking.firewall.allowedTCPPorts = [ 3501 ];

    systemd.services.playwright-server = {
        description = "playwright-server agent";
        after = [ "network.target" ];

        script = ''
            export HOST=$(echo $HOST) 
            ${inputs.playwright-server.apps.${pkgs.system}.default.program} 
        '';

        serviceConfig = {
            Restart = "always";
        };

        wantedBy = [ "multi-user.target" ];
    };
}
