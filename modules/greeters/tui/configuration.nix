{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.greeter;
    hyprland = if configurationName == "uconsole" then "uconsole-hyprland" else "hyprland";
    hyprlandPackage = inputs.${hyprland}.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    startHyprland = "${hyprlandPackage}/bin/start-hyprland";
    tuigreetCommand = lib.concatStringsSep " " [
        "${pkgs.tuigreet}/bin/tuigreet"
        "--greeting 'Welcome Mr_Craft'"
        "--asterisks"
        "--remember"
        "--remember-user-session"
        "--time"
        "--cmd ${startHyprland}"
    ];
in {
    config = lib.mkIf (cfg == "tui") {
        services.greetd = {
            enable = true;
            settings = {
                initial_session = {
                    command = startHyprland;
                    user = "craft";
                };
                default_session = {
                    command = tuigreetCommand;
                    user = "greeter";
                };
            };
        };
    };
}
