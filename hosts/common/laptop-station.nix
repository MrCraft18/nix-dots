{ ... }:

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

    programs.kitty.terminfo.enable = true;

    networking.firewall.allowedTCPPorts = [ 3501 ];
}
