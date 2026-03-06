{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
in {
    config = lib.mkIf (cfg == "hyprland-onedarkpro") {
        home-manager.config.moduleLoadout.desktop = "hyprland-onedarkpro";
    };
}
