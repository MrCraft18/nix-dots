{ lib, buildScope, ... }:

let
    directoryNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
    paths = builtins.map (directory: ./. + "/${directory}") directoryNames;
in {
    imports = paths;

    options.moduleLoadout.greeter = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Desktop module selection";
    };
} // (if (buildScope == "nix-on-droid") then {
    config.home-manager.config = { lib, ... }: {
        options.moduleLoadout.greeter = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Desktop module selection";
        };
    };
} else {})
