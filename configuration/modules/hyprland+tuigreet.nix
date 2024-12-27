
{ inputs, config, pkgs, ... }:

{
    programs.hyprland = {
        enable = true;
        package = inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland;
        # portalPackage = inputs.uconsole-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        # package = inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland.override {
        #     legacyRenderer = true;
        #     mesa = pkgs.mesa;
        # };
        # xwayland.enable = true;
    };
    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "${inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
                user = "user";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS' --asterisks --remember --remember-user-session --time --cmd ${inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
                user = "greeter";
            };
        };
    };
}
