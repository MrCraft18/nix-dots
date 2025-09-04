{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.udiskie;
in {
    options.moduleLoadout.services.udiskie = {
        enable = lib.mkEnableOption "udiskie service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.services.udiskie.enable = true;

        services.udisks2.enable = true;
    };
}
