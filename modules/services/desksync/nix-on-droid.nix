{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.desksync;
in {
    options.moduleLoadout.services.desksync = {
        enable = lib.mkEnableOption "desksync service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.services.desksync.enable = true;
    };
}
