{ inputs, ... }:

{
    imports = [
        inputs.stylix.nixOnDroidModules.stylix
        ./stylix.nix
    ];
}
