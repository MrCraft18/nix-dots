{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.retroarch;
in {
    options.moduleLoadout.applications.retroarch = {
        enable = lib.mkEnableOption "retroarch module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.applications.retroarch.enable = true;
    };
}
