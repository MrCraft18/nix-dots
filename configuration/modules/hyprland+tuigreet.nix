{ inputs, pkgs, host, ... }:

let 
    hyprland-package = if host == "uconsole" then
            inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland
        else 
            inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
    programs.hyprland = {
        enable = true;
        package = hyprland-package; 
        xwayland.enable = true;
    };

    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "${hyprland-package}/bin/Hyprland";
                user = "user";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS' --asterisks --remember --remember-user-session --time --cmd ${hyprland-package}/bin/Hyprland";
                user = "greeter";
            };
        };
    };
}
