{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.git;
in {
    options.moduleLoadout.programs.git = {
        enable = lib.mkEnableOption "git program module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.users.craft.moduleLoadout.programs.git.enable = true;
    };
}
