{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.fileBrowser;
in {
    config = lib.mkIf (cfg == "yazi") {
        home-manager.config.moduleLoadout.terminal.fileBrowser = "yazi";
    };
}
