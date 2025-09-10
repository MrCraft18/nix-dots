{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.zen-browser;
in {
    options.moduleLoadout.applications.zen-browser = {
        enable = lib.mkEnableOption "zen-browser application module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.applications.zen-browser.enable = true;
    };
}
