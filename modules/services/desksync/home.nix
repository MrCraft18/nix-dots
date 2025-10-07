{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.desksync;
in {
    options.moduleLoadout.services.desksync = {
        enable = lib.mkEnableOption "desksync service module";
    };

    config = lib.mkIf cfg.enable {
        programs.lan-mouse = {
            enable = true;
        };

        home.packages = [
            pkgs.pulseaudioFull
        ];
    };
}
