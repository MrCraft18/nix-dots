{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.greeter;
in {
    config = lib.mkIf (cfg == "tui") {
        
    };
}
