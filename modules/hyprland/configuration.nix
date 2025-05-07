{ pkgs, lib, inputs, host, ... }:

let
    hyprland = if host == "uconsole" then "uconsole-hyprland" else "hyprland";
in {
    home-manager.users.craft.imports = [ ./home.nix ];

    hardware.graphics = {
        enable = true;
        package = if host == "uconsole"
            then inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers
            else inputs.${hyprland}.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa;

        enable32Bit = lib.mkIf (pkgs.system != "aarch64-linux") true;
        package32 = inputs.uconsole-hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa;
    };
}
