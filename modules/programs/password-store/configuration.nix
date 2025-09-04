{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.password-store;
in {
    options.moduleLoadout.programs.password-store = {
        enable = lib.mkEnableOption "password-store program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.programs.password-store.enable = true;
    };
}
