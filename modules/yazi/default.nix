{ buildScope, lib, ... }:

let
    imports = {
        nixos = [ ./configuration.nix ];
        home-manager = [ ./home.nix ];
        nix-on-droid = [];
    }."${buildScope}";
in {
    inherit imports;

    home-manager = lib.mkIf (buildScope == "nix-on-droid") {
        config.imports = [ ./home.nix ];
    };
}
