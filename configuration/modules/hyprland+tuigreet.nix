
{ config, pkgs, ... }:

{
    programs.hyprland.enable = true;
    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "${pkgs.hyprland}/bin/Hyprland";
                user = "user";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
                user = "greeter";
            };
        };
    };
}
