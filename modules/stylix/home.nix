{ lib, inputs, buildScope, ... }:

{
    imports = lib.mkIf (buildScope == "home-manager") [
        inputs.stylix.homeManagerModules.stylix
        ./stylix.nix
    ];
}
