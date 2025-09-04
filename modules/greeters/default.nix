{ lib, ... }:

let
    directoryNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
    paths = builtins.map (directory: ./. + "/${directory}") directoryNames;
in {
    imports = paths;

    options.moduleLoadout.greeter = lib.mkOption {
        type = lib.types.str;
        description = "Desktop module selection";
    };
}
