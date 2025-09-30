{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
    hyprland = if configurationName == "uconsole" then "uconsole-hyprland" else "hyprland";
in {
    config = lib.mkIf (cfg == "hyprland-onedarkpro") {
        home-manager.users.craft.imports = [ ./home.nix ];

        stylix = {
            enable = true;

            base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
            
            image = config.lib.stylix.pixel "base00";
        };

        home-manager.users.craft.moduleLoadout.desktop = "hyprland-onedarkpro";

        hardware.graphics = {
            enable = true;
            package = if configurationName == "uconsole"
                then inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers
                else inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa;

            enable32Bit = lib.mkIf (pkgs.system != "aarch64-linux") true;
            package32 = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa;
        };

        programs.hyprland = {
            enable = true;
            withUWSM = true;

            xwayland.enable = true;

            package = inputs.${hyprland}.packages.${pkgs.system}.hyprland;
            portalPackage = inputs.${hyprland}.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        };
    };
}
