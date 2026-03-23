{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
in {
    config = lib.mkIf (cfg == "tmux") {
        home-manager.config.moduleLoadout.terminal.multiplexer = "tmux";
    };
}
