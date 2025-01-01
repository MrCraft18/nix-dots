{ inputs, pkgs, host, ... }:

let 
    # hyprland-package = if host == "uconsole" then
    #         inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland
    #     else 
    #         inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
    programs.hyprland = {
        enable = true;
        package = inputs.uconsole-hyprland.packages.${pkgs.system}.hyprland; 
        portalPackage = inputs.uconsole-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        # xwayland.enable = true;
    };

    hardware.graphics = {
        enable = true;
        package = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;

        # driSupport32Bit = true;
        # package32 = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa.drivers;
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
