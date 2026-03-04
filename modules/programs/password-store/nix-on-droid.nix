{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.password-store;
in {
    options.moduleLoadout.programs.password-store = {
        enable = lib.mkEnableOption "password-store program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.programs.password-store.enable = true;
    };
}
