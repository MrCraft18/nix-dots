{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
in {
    config = lib.mkIf (cfg == "zellij") {
        home-manager.config.moduleLoadout.terminal.multiplexer = "zellij";
    };
}
