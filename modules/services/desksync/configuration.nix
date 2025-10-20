{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.desksync;
in {
    options.moduleLoadout.services.desksync = {
        enable = lib.mkEnableOption "desksync service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.services.desksync.enable = true;

        networking.firewall.interfaces."tailscale0".allowedUDPPorts = [ 4242 ];
        networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4242 ];
    };
}
