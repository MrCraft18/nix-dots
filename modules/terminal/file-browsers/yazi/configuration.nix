{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.fileBrowser;
in {
    config = lib.mkIf (cfg == "yazi") {
        home-manager.users.craft.moduleLoadout.terminal.fileBrowser = "yazi";
    };
}
