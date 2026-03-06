{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.emulator;
in {
    config = lib.mkIf (cfg == "kitty") {
        home-manager.config.moduleLoadout.terminal.emulator = "kitty";
    };
}
