{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.opencode;
in {
    options.moduleLoadout.programs.opencode = {
        enable = lib.mkEnableOption "opencode program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.programs.opencode.enable = true;
    };
}
