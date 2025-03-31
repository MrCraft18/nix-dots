{ inputs, pkgs, host, ... }:

{
    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "Hyprland";
                user = "craft";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet \
                    --greeting 'Welcome to NixOS' \
                    --asterisks \
                    --remember \
                    --remember-user-session \
                    --time \
                    --cmd Hyprland";
                user = "greeter";
            };
        };
    };
}
