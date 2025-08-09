{ lib, inputs, buildScope, ... }:

{
    imports = lib.optionals (buildScope == "home-manager") [
        inputs.stylix.homeManagerModules.stylix
        ./stylix.nix
    ];

    stylix.targets.waybar.addCss = false;
    stylix.targets.zen-browser.profileNames = [ "default" ];
}
