{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
in {
    config = lib.mkIf (cfg == "tmux") {
        home-manager.users.craft.moduleLoadout.terminal.multiplexer = "tmux";
    };
}
