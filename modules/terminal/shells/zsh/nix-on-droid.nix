{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.shell;
in {
    config = lib.mkIf (cfg == "zsh") {
        home-manager.config.moduleLoadout.terminal.shell = "zsh";
    };
}
