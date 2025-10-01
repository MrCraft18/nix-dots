{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.zen-browser;
in {
    options.moduleLoadout.applications.zen-browser = {
        enable = lib.mkEnableOption "zen-browser module";
    };

    config = lib.mkIf cfg.enable {
        programs.zen-browser  = {
            enable = true;

            profileVersion = null;

            profiles."default" = {
                id = 0;
                isDefault = true;
            };
        };

        stylix.targets.zen-browser.profileNames = [ "default" ];
    };
}
