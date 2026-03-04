{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.git;
in {
    options.moduleLoadout.programs.git = {
        enable = lib.mkEnableOption "git program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.programs.git.enable = true;
    };
}
