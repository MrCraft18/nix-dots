{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.editor;
in {
    config = lib.mkIf (cfg == "nvf") {
        home-manager.config.moduleLoadout.terminal.editor = "nvf";
    };
}
