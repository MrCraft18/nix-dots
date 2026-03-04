{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
in {
    config = lib.mkIf (cfg == "i3") {

    };
}
