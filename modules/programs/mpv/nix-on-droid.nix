{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.mpv;
in {
    options.moduleLoadout.programs.mpv = {
        enable = lib.mkEnableOption "mpv program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.programs.mpv.enable = true;
    };
}
