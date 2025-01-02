{ inputs, pkgs, host, ... }:

let 
    hyprland = if host == "uconsole" then "uconsole-hyprland" else "hyprland";
in {
    programs.hyprland = {
        enable = true;
        package = inputs.${hyprland}.packages.${pkgs.system}.hyprland; 
        # portalPackage = inputs.${hyprland}.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
    };

    environment.sessionVariables = if host == "desktop" then {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
    } else {};

    hardware.graphics = {
        enable = true;
        package = inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;

        # driSupport32Bit = true;
        # package32 = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa.drivers;
    };

    hardware.nvidia.modesetting.enable = if host == "desktop" then true else false;

    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "${inputs.${hyprland}.packages.${pkgs.system}.hyprland}/bin/Hyprland";
                user = "user";
            };
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS' --asterisks --remember --remember-user-session --time --cmd ${inputs.${hyprland}.packages.${pkgs.system}.hyprland}/bin/Hyprland";
                user = "greeter";
            };
        };
    };
}
