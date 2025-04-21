{ pkgs, inputs, host, ... }:

let
    hyprland = if host == "uconsole" then "uconsole-hyprland" else "hyprland";
in {
    home-manager.users.craft.imports = [ ./home.nix ];

    hardware.graphics = {
        enable = true;
        # package = inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;

        enable32Bit = true;
        # package32 = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa.drivers;
    };
}
