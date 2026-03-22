{ configurationName, config, lib, options, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.vesktop;
in {
    options.moduleLoadout.applications.vesktop = {
        enable = lib.mkEnableOption "vesktop module";
    };

    config = lib.mkIf cfg.enable ({
        programs.vesktop = {
            enable = true;

            vencord = {
                themes = {
                    "system24" = ./themes/system24.theme.css;
                };

                settings = {
                    enabledThemes = [ "system24.css" ];
                };
            };
        };
    } // lib.optionalAttrs (lib.hasAttrByPath [ "stylix" ] options) {
        stylix.targets.vesktop.enable = false;
    });
}
