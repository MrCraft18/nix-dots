{ lib, buildScope, ... }:

let
    directoryNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
    paths = builtins.map (directory: ./. + "/${directory}") directoryNames;
in {
    imports = paths;

    options.moduleLoadout.terminal.shell = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Terminal shells module selection";
    };
} // (if (buildScope == "nixos") then {
    config.home-manager.users.craft = { lib, ... }: {
        options.moduleLoadout.terminal.shell = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Terminal shells module selection";
        };
    };
} else {})
