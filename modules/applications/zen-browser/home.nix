{ config, options, lib, pkgs, ... }:
let
    cfg = config.moduleLoadout.applications.zen-browser;
in {
    options.moduleLoadout.applications.zen-browser.enable = lib.mkEnableOption "zen-browser module";

    config = lib.mkIf cfg.enable (
        {
            programs.zen-browser = {
                enable = true;
                profileVersion = null;
                profiles = {
                    default = { id = 0; isDefault = true; };
                    wanky   = { id = 1; isDefault = false; };
                };
            };
        } // lib.optionalAttrs (lib.hasAttrByPath [ "stylix" ] options) {
            stylix.targets."zen-browser".profileNames = [ "default" ];
        }
    );
}
