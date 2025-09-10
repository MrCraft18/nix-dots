{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.emulator;
in {
    config = lib.mkIf (cfg == "kitty") {
        home-manager.users.craft.moduleLoadout.terminal.emulator = "kitty";
    };
}
