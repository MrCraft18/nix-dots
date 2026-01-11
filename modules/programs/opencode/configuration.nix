{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.opencode;
in {
    options.moduleLoadout.programs.opencode = {
        enable = lib.mkEnableOption "opencode program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.programs.opencode.enable = true;
    };
}
