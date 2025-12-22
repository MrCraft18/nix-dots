{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.codex;
in {
    options.moduleLoadout.programs.codex = {
        enable = lib.mkEnableOption "codex program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.programs.codex.enable = true;
    };
}
