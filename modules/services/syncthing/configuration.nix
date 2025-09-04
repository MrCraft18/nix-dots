{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.syncthing;
in {
    options.moduleLoadout.services.syncthing = {
        enable = lib.mkEnableOption "syncthing service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.services.syncthing.enable = true;
    };
}
