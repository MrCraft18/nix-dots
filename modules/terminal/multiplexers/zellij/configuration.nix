{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
in {
    config = lib.mkIf (cfg == "zellij") {
        home-manager.users.craft.moduleLoadout.terminal.multiplexer = "zellij";
    };
}
