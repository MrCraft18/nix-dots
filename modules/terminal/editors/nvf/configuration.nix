{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.editor;
in {
    config = lib.mkIf (cfg == "nvf") {
        home-manager.users.craft.moduleLoadout.terminal.editor = "nvf";
    };
}
