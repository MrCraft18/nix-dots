{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.greeter;
in {
    config = lib.mkIf (cfg == "tui") {
        services.greetd = {
            enable = true;
            settings = {
                initial_session = {
                    command = "Hyprland";
                    user = "craft";
                };
                default_session = {
                    command = "${pkgs.tuigreet}/bin/tuigreet \
                        --greeting 'Welcome Mr_Craft' \
                        --asterisks \
                        --remember \
                        --remember-user-session \
                        --time \
                        --cmd Hyprland";
                    user = "greeter";
                };
            };
        };
    };
}
