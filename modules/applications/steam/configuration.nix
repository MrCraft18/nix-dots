{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.steam;
in {
    options.moduleLoadout.applications.steam = {
        enable = lib.mkEnableOption "steam application module";
    };

    config = lib.mkIf cfg.enable {
        programs.steam = {
            enable = true;
            extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
    };
}
