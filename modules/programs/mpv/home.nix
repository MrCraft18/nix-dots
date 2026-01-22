{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.mpv;
in {
    options.moduleLoadout.programs.mpv = {
        enable = lib.mkEnableOption "mpv program module";
    };

    config = lib.mkIf cfg.enable {
        programs.mpv = {
            enable = true;

            config = {
                volume-max = 300;
                image-display-duration = "inf";
            };
        };
    };
}
