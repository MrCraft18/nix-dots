{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.steam;
in {
    options.moduleLoadout.applications.steam = {
        enable = lib.mkEnableOption "steam application module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.applications.steam.enable = true;
    };
}
