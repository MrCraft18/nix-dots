{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.vesktop;
in {
    options.moduleLoadout.applications.vesktop = {
        enable = lib.mkEnableOption "vesktop module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.applications.vesktop.enable = true;
    };
}
